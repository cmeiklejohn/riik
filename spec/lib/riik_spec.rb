require 'spec_helper'

module Riik
  class Person
    include Riik::RObject

    initializes_with :first_name, :last_name
  end

  describe Person do
    let(:arguments) { ['Fat', 'Mike'] }

    subject { Person }

    it 'can be created in riak' do
      VCR.use_cassette('creation_of_nonexistent_key') do
        subject.create(*arguments).should be_an_instance_of(Person)
      end
    end

    context 'created in memory' do
      subject { Person.new(*arguments) }

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

    context 'in riak' do
      subject { Person.find('03c4a0b552a61864c7c5380828e21b17') }

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
    end
  end
end
