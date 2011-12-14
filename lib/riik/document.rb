module Riik

  # Document is the base object for the Riik ORM.  Including it provides
  # the basic functionality for assigning attributes to models,
  # assigning a bucket name, and serializing objects.
  #
  module Document
    autoload :Persistence, 'riik/document/persistence'
    autoload :Finders,     'riik/document/finders'

    def self.included(base)
      base.send :extend, ClassMethods

      base.send :include, Finders
      base.send :include, Persistence
    end

    module ClassMethods

      # List of model properties that should be assigned from the attributes
      # hash.
      #
      attr_reader :riik_attributes

      # Create accessors for each of the properties of the model.
      #
      # @private
      #
      def property(attribute)
        @riik_attributes ||= []
        @riik_attributes << attribute

        attr_accessor attribute
      end

      # Returns the Riak bucket for this object.
      #
      # @return [Riak::Bucket]
      #
      def bucket
        @bucket ||= Riik.client.bucket(bucket_name)
      end

      # Returns the bucket name for this object.  Override in your class
      # to change.
      #
      # @return [String] bucket name.
      #
      def bucket_name
        self.to_s.gsub(/::/, '_').downcase
      end
    end

    # Assign model attributes through initialization hash.
    #
    # @param [Hash] attributes
    #
    def initialize(attributes = {})
      attributes.symbolize_keys.each do |key, value|
        if riik_attributes.include?(key)
          instance_variable_set "@#{key}", value
        end
      end
    end

    # Serialize the attributes of this model.
    #
    # @return [Hash] serialized attributes.
    # @private
    #
    def attributes
      Hash[riik_attributes.zip(riik_attributes.map { |attr| instance_variable_get "@#{attr}" })]
    end

    # Return the riik attribute list for this class.
    #
    # @return [Array] symbols for each model property.
    # @private
    #
    def riik_attributes
      self.class.riik_attributes
    end

    # Return the bucket for this class.
    #
    # @return [Riak::Bucket]
    #
    def bucket
      self.class.bucket
    end

    # Delegate the object key to the Riak object.
    # 
    # @return [String]
    #
    def key
      robject.key
    end

    # Store the current Riak client object.
    #
    attr_accessor :robject

    # Create or return the current Riak client object.
    #
    # @return [Riak::RObject]
    #
    def robject
      key = self.respond_to?(:default_key) ? self.default_key : nil

      @robject ||= Riak::RObject.new(bucket, key).tap do |object|
        object.content_type = "application/json"
      end
    end
  end



end
