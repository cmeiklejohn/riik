require 'spec_helper'

module Riik
  describe self do
    subject { Riik } 

    let(:client) { Riak::Client.new }

    it 'has a client' do 
      subject.client.should be_a_kind_of(Riak::Client)
    end

    it 'has a client that can be set' do
      subject.client = client
      subject.client.should == client
    end
  end
end
