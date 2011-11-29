module Riik
  module Document
    autoload :Persistence, 'riik/document/persistence'
    autoload :Finders,     'riik/document/finders'

    def self.included(base)
      base.send :extend, ClassMethods

      base.send :include, Finders
      base.send :include, Persistence
    end

    module ClassMethods
      attr_reader :riik_attributes

      def property(attribute)
        @riik_attributes ||= []
        @riik_attributes << attribute

        attr_accessor attribute
      end

      def bucket
        @bucket ||= Riik.client.bucket(bucket_name)
      end

      def bucket_name
        self.to_s.gsub(/::/, '_').downcase
      end
    end

    def initialize(attributes = {})
      attributes.symbolize_keys.each do |key, value|
        if riik_attributes.include?(key)
          instance_variable_set "@#{key}", value
        end
      end
    end

    def attributes
      Hash[riik_attributes.zip(riik_attributes.map { |attr| instance_variable_get "@#{attr}" })]
    end

    def riik_attributes
      self.class.riik_attributes
    end

    def bucket
      self.class.bucket
    end

    def key
      robject.key
    end

    attr_accessor :robject

    def robject
      @robject ||= Riak::RObject.new(bucket).tap do |object|
        object.content_type = "application/json"
      end
    end
  end
end
