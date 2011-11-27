require 'spec_helper'

module Riik
  class Person
    include Riik::Document
    initializes_with :first_name, :last_name
  end

  describe Person do
    let(:arguments) { ['Fat', 'Mike'] }

    subject { person }

    let(:person) { Person }

    it 'can be created in riak' do
      VCR.use_cassette('creation_of_nonexistent_key') do
        subject.create(*arguments).should be_an_instance_of(Person)
      end
    end

    it 'with different attributes from the first will not have the same key' do
      VCR.use_cassette('creation_of_nonexistent_keys') do
        person1 = subject.create('Fat', 'Mike')
        person2 = subject.create('El', 'Hefe')
        person1.key.should_not == person2.key
      end
    end

    it 'handles extra arguments correctly by applying them to the last attribute' do
      VCR.use_cassette('creation_of_nonexistent_key_with_extra_args') do
        person = subject.create('Jan', 'Michael', 'Vincent')
        person.should be_an_instance_of(Person)
        person.first_name.should == 'Jan'
        person.last_name.should == ['Michael', 'Vincent']
      end
    end

    context 'a new person with an forced nil key' do
      let(:person) { Person.new(*arguments).tap { |o| o.key = nil } }

      it 'can be saved with the default key' do
        VCR.use_cassette('creation_of_nonexistent_key_using_default_key') do
          subject.save.should be_true
          subject.key.should == subject.default_key
        end
      end
    end

    context 'a new person with an forced blank key' do
      let(:person) { Person.new(*arguments).tap { |o| o.key = "" } }

      it 'can be saved with the default key' do
        VCR.use_cassette('creation_of_nonexistent_key_using_default_key') do
          subject.save.should be_true
          subject.key.should == subject.default_key
        end
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
          expect {
            subject.should_not be_an_instance_of(Person)
          }.to raise_error(Riak::HTTPFailedRequest)
        end
      end
    end

    context 'in riak' do
      before do
        VCR.use_cassette('creation_of_nonexistent_key') do
          Person.create(*arguments)
        end
      end

      let(:person) { Person.find('ac247a5f9fd11735da5cfcb1a67d9c4e37ad53d1') }

      it 'can be found by key' do
        VCR.use_cassette('loading_of_valid_key') do
          subject.should be_an_instance_of(Person)
        end
      end

      it 'can be reloaded' do
        VCR.use_cassette('loading_of_valid_key') do
          subject.reload.should be_true
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
          
          subject.load('ac247a5f9fd11735da5cfcb1a67d9c4e37ad53d1')

          subject.first_name.should == 'Eric'
          subject.last_name.should  == 'Melvin'
        end
      end
    end
  end
end
