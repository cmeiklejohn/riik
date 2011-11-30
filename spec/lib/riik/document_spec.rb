require 'spec_helper'

module Riik
  describe Document do 
    subject { person }

    let(:person) { Person }

    it 'contains a bucket name derived from the name' do
      subject.bucket_name.should == "riik_person"
    end

    it 'contains a bucket' do
      subject.bucket.should be_an_instance_of(Riak::Bucket)
    end

    context 'an empty document' do 
      let(:person) { Person.new } 

      it 'knows its properties' do 
        [:first_name, :last_name].each do |attr|
          subject.class.riik_attributes.should include(attr)
        end
      end

      it 'responds to properties' do 
        [:first_name, :last_name].each do |attr|
          subject.should respond_to(attr)
        end
      end

      it 'contains a robject of content type json' do 
        subject.robject.should be_an_instance_of(Riak::RObject)
        subject.robject.content_type.should == "application/json"
      end
    end

    context 'with some attributes' do 
      let(:person) { Person.new(attributes) } 

      let(:attributes) do 
        { :first_name => 'Fat', :last_name => 'Mike' }
      end

      it 'assigns properties through an attributes hash' do
        attributes.each do |key, value|
          subject.send(key).should == value
        end
      end

      it 'has a valid attributes hash' do
        attributes.should == subject.attributes
      end
    end
  end
end
