module Riik

  # Document provides a mixin interface for creating and working with
  # Riik objects.
  #
  # Each class that includes Document can override the methods in this
  # class for custom behavior regarding how the document is saved to
  # Riak, where it's save, which client, etc.
  #
  module Document
    def self.included(base)
      base.send :extend,  Configuration
      base.send :include, Persistence
    end

    # Returns the key that should be used to save the Riak object if no
    # key is present.
    #
    # @return [String] key 
    #
    def default_key 
      Digest::SHA1.hexdigest(attributes.to_json)
    end

    # Defines the content type that should be used to save the Riak
    # object.
    #
    # @return [String] content-type
    #
    def content_type 
      "application/json"
    end

    # Defines which bucket this class should create keys in.
    #
    # @return [Riak::Bucket] Riak bucket instance.
    #
    def bucket
      client.bucket("riik")
    end

    # Defines which client this class should search for buckets in.
    #
    # @return [Riak::Client] Riak client instance.
    #
    def client
      Riak::Client.new
    end

    # Delegate list of riik attributes to the class-level.
    # 
    # @private
    #
    def riik_attributes
      self.class.riik_attributes
    end
    private :riik_attributes

    # Defines how the attributes get assembled into a hash for
    # serialization.
    #
    # @private
    #
    def attributes
      Hash[riik_attributes.map { |key| [key, instance_variable_get("@#{key}")] }]
    end
    private :attributes
  end
end
