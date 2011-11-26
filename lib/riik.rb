require 'riik/version'
require 'riak'

module Riik
  module RObject
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :riik_attributes

      def initializes_with(*args)
        @riik_attributes = args

        args.each do |arg|
          attr_accessor arg.to_sym
        end
      end
    end

    def initialize(*args)
      args.each_with_index do |arg, i|
        attribute = self.class.riik_attributes[i]
        instance_variable_set "@#{attribute}", arg
      end
    end

    def save
      Riak::RObject.new(bucket, key).tap do |robject|
        robject.content_type = content_type
        robject.data = encoded
        robject.store
      end
    end

    def data
      Hash[self.class.riik_attributes.map { |key| [key, self.instance_variable_get("@#{key}")] }]
    end

    def encoded 
      data.to_json
    end

    def key 
      Digest::MD5.hexdigest(encoded)
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
