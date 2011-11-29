require 'riik/version'
require 'riak'

module Riik
  autoload :Document, 'riik/document'

  module Document
    autoload :Persistence, 'riik/document/persistence'
  end

  class << self
    def client=(client)
      @client = client
    end

    def client
      @client ||= Riak::Client.new
    end
  end
end
