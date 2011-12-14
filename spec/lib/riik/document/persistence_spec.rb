require 'spec_helper'

module Riik
  module Document
    describe Persistence do
      subject { person }

      context 'when creating' do 
        let(:person) { Person } 

        let(:attributes) do 
          { :first_name => 'Fat', :last_name => 'Mike' }
        end

        it 'can be created' do 
          VCR.use_cassette('creation_of_nonexistent_key') do 
            subject.create(attributes).should be_an_instance_of(Person)
          end
        end

        context 'once created with a default key' do 
          let(:person) do 
            VCR.use_cassette('creation_of_nonexistent_default_key') do 
              DefaultKeyPerson.create(attributes)
            end
          end

          it 'should exist in riak correctly' do
            VCR.use_cassette('loading_of_valid_default_key') do 
              subject.bucket.get(subject.default_key).should be_an_instance_of(Riak::RObject)

              attributes.each do |key, value|
                subject.send(key).should == value
              end
            end
          end
        end

        context 'once created' do 
          let(:person) do 
            VCR.use_cassette('creation_of_nonexistent_key') do 
              Person.create(attributes)
            end
          end

          it 'should exist in riak correctly' do
            VCR.use_cassette('loading_of_valid_key') do 
              subject.bucket.get(subject.key).should be_an_instance_of(Riak::RObject)

              attributes.each do |key, value|
                subject.send(key).should == value
              end
            end
          end

          it 'can be updated' do 
            VCR.use_cassette('updating_of_valid_key') do 
              subject.first_name = 'Eric'
              subject.last_name  = 'Melvin'
              subject.save
            end
          end

          it 'can be destroyed' do 
            VCR.use_cassette('deletion_of_valid_key') do 
              subject.destroy
            end
          end
        end
      end
    end
  end
end
