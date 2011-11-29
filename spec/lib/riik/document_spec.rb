require 'spec_helper'

module Riik
  describe Document do 

    subject { person }

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

      it 'contains a bucket derived from the name' do
        subject.bucket.should == "riik_person"
      end

      it 'contains a robject of content type javascript' do 
        subject.robject.should be_an_instance_of(Riak::RObject)
        subject.robject.content_type.should == "application/javascript"
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
    end

  end
end
