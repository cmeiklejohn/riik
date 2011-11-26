require 'spec_helper'

module Riik
  class Person
    include Riik::RObject

    initializes_with :first_name, :last_name
  end

  describe Person do 
    context 'created in memory' do
      subject { Person.new('Fat', 'Mike') }

      it 'has appropriately initialized attributes' do 
        subject.first_name.should == 'Fat'
        subject.last_name.should  == 'Mike'
      end

      it 'saves to riak' do
        VCR.use_cassette('nonexistent_key') do 
          subject.save.should be_true
        end
      end
    end
  end
end
