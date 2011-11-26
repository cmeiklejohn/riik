require 'riik/version'
require 'riak'

module Riik
  autoload :Configuration, 'riik/configuration'
  autoload :Persistence,   'riik/persistence'

  module RObject
    def self.included(base)
      base.send :extend,  Configuration
      base.send :include, Persistence
    end

    def riik_attributes
      self.class.riik_attributes
    end

    def attributes
      Hash[riik_attributes.map { |key| [key, instance_variable_get("@#{key}")] }]
    end

    def key 
      Digest::SHA1.hexdigest(attributes.to_json)
    end

    def content_type 
      "application/json"
    end

    def bucket
      client.bucket("riik")
    end

    def client
      Riak::Client.new
    end
  end
end
