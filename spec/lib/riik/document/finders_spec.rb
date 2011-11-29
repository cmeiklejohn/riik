require 'spec_helper'

module Riik
  module Document
    describe Finders do
      context 'when finding a valid key' do
        subject { person }

        let(:preexisting_record) do
          VCR.use_cassette('creation_of_nonexistent_key') do
            Person.create(attributes)
          end
        end

        let(:attributes) do
          { :first_name => 'Fat', :last_name => 'Mike' }
        end

        it 'can be found' do
          VCR.use_cassette('loading_of_valid_key') do
            Person.find(preexisting_record.key).should be_an_instance_of(Person)
          end
        end

        context 'when found' do
          let(:person) do
            VCR.use_cassette('loading_of_valid_key') do
              Person.find(preexisting_record.key)
            end
          end

          it 'sets the riak client object' do
            subject.robject.should be_an_instance_of(Riak::RObject)
          end

          it 'set the model attributes' do
            attributes.each do |key, value|
              subject.send(key).should == value
            end
          end
        end

        context 'when not found' do 
          let(:person) do
            VCR.use_cassette('loading_of_valid_key') do
              Person.find('invalid')
            end
          end

          it 'returns nil if it can not be found' do
            expect { subject.should be_nil }.to raise_error
          end
        end
      end
    end
  end
end
