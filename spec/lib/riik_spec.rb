require 'spec_helper'

module Riik
  class Person
    include Riik::RObject
    initializes_with :first_name, :last_name
  end

  describe Person do
    subject { person }

    let(:arguments) { ['Fat', 'Mike'] }
    let(:person) { Person }

    it 'can be created in riak' do
      VCR.use_cassette('creation_of_nonexistent_key') do
        subject.create(*arguments).should be_an_instance_of(Person)
      end
    end

    context 'created in memory' do
      let(:person) { Person.new(*arguments) }

      it 'has appropriately initialized attributes' do
        subject.first_name.should == 'Fat'
        subject.last_name.should  == 'Mike'
      end

      it 'saves to riak' do
        VCR.use_cassette('creation_of_nonexistent_key') do
          subject.save.should be_true
        end
      end
    end

    context 'not in riak' do
      let(:person) { Person.find('invalid-key') }

      it 'is not found' do
        VCR.use_cassette('loading_of_invalid_key') do
          expect { subject.should_not be_an_instance_of(Person) }.to raise_error(Riak::HTTPFailedRequest)
        end
      end
    end

    context 'in riak' do
      before do
        VCR.use_cassette('creation_of_nonexistent_key') do
          Person.create(*arguments)
        end
      end

      let(:person) { Person.find('03c4a0b552a61864c7c5380828e21b17') }

      it 'can be found by key' do
        VCR.use_cassette('loading_of_valid_key') do
          subject.should be_an_instance_of(Person)
        end
      end

      it 'has appropriately initialized attributes' do
        VCR.use_cassette('loading_of_valid_key') do
          subject.first_name.should == 'Fat'
          subject.last_name.should  == 'Mike'
        end
      end

      it 'can be destroyed and not reloaded' do
        VCR.use_cassette('destruction_of_valid_key') do
          subject.destroy.should be_true
          expect { subject.reload }.to raise_error(Riak::HTTPFailedRequest)
        end
      end

      it 'can be updated and retain the same key' do
        VCR.use_cassette('updating_of_valid_key') do
          subject.first_name = 'Eric'
          subject.last_name  = 'Melvin'

          subject.save
          subject.reload

          subject.first_name.should == 'Eric'
          subject.last_name.should  == 'Melvin'
          
          subject.load('03c4a0b552a61864c7c5380828e21b17')

          subject.first_name.should == 'Eric'
          subject.last_name.should  == 'Melvin'
        end
      end
    end
  end
end
