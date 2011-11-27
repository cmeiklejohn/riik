module Riik

  # Persistence provides basic class-level finders, and functions used
  # to serialize the object and save to Riak.
  #
  module Persistence

    def self.included(base)
      base.extend(ClassMethods)
    end

    # Set the Riak key for this record.
    #
    attr_accessor :key

    # Key to use when saving the object.
    #
    # @return [String] key.
    #
    def key 
      @key && !@key.empty? ? @key : default_key
    end

    # Store the Riak object for this record.
    #
    attr_accessor :robject 

    # Return the already initialized riak object if we have it, if not
    # generate a new one.
    # 
    # @return [Riak::RObject] riak object 
    #
    def robject
      @robject ||= Riak::RObject.new(bucket, key)
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
    end

    # Save an object to Riak.
    #
    # @return [Object] object.
    #
    def save
      robject.content_type = content_type
      robject.data = attributes
      robject.store
    end

    # Load an object from Riak into an object.
    #
    # @param [String] key.
    # @return [Object] object.
    #
    def load(key)
      build(robject.data) if get(key)
      self
    end

    # Get a key from Riak.
    #
    # @param [String] key.
    # @return [Riak::RObject] riak object.
    #
    def get(key)
      @robject = bucket.get(key)
    end

    # Destroy an object.
    #
    # @return [Object] object.
    #
    def destroy
      robject.delete
    end

    # Reload an object from Riak.
    #
    # @return [Object] returns reinitialized object.
    #
    def reload
      load(key) ? true : false
    end

    # Load the given key/value pairs into the current object.
    #
    # @param [Hash] key/value attributes hash for object.
    # @return [Object] object with attributes loaded.
    # @private
    #
    def build(attributes) 
      if attributes
        attributes.each do |key, value|
          instance_variable_set "@#{key}", value
        end
      end
      self
    end
    private :build

    # Convert the argument list to a hash of key/value pairs.
    #
    # @param [Array] argument list for object
    # @return [Hash] key/value attributes hash for object.
    # @private
    #
    def arguments_to_attributes(*args)
      attributes = riik_attributes.each_with_index.map do |attribute, i|
        if i == riik_attributes.length - 1 && args.length > 1
          [attribute, args]
        else
          [attribute, args.slice!(0)]
        end
      end
      Hash[attributes]
    end
    private :arguments_to_attributes

  end

end
