module Riik

  # Persistence provides basic class-level finders, and functions used
  # to serialize the object and save to Riak.
  #
  module Persistence
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Creates a new object and saves to Riak.
      #
      # @param [Array] argument list for object.
      # @return [Object] object.
      #
      def create(*args)
        self.new(*args).tap do |o|
          o.save
        end
      end

      # Find a object by it's Riak key.
      #
      # @param [String] key.
      # @return [Object] object.
      #
      def find(key)
        self.new.load(key)
      end

    end

    # Initialize a new object.
    #
    # @param [Array] argument list for object.
    # @return [Object] object.
    #
    def initialize(*args)
      build(arguments_to_attributes(*args))
      self
    end

    # Save an object to Riak.
    #
    # @return [Object] object.
    #
    def save
      Riak::RObject.new(bucket, key).tap do |robject|
        robject.content_type = content_type
        robject.data = attributes
        robject.store
      end
    end

    # Reload an object from Riak.
    #
    # @return [Object] returns reinitialized object.
    #
    def reload
      load(key)
    end

    # Load an object from Riak.
    #
    # @return [Object] object.
    #
    def load(key)
      build(bucket.get(key).data)
      self
    end

    # Convert the argument list to a hash of key/value pairs.
    #
    # @param [Array] argument list for object
    # @return [Hash] key/value attributes hash for object.
    # @private
    #
    def arguments_to_attributes(*args)
      Hash[args.each_with_index.map { |arg, i| [riik_attributes[i], arg] }]
    end
    private :arguments_to_attributes

    # Load the given key/value pairs into the current object.
    #
    # @param [Hash] key/value attributes hash for object.
    # @return [Object] object with attributes loaded.
    # @private
    #
    def build(attributes) 
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
      self
    end
    private :build

  end
end
