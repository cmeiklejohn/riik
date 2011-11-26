module Riik
  module Persistence
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def create(*args)
        self.new(*args).tap do |o|
          o.save
        end
      end
      
      def find(key)
        self.new.load(key)
      end
    end

    def initialize(*args)
      self.build(arguments_to_attributes(*args))
      self
    end

    def save
      Riak::RObject.new(bucket, key).tap do |robject|
        robject.content_type = content_type
        robject.data = attributes
        robject.store
      end
    end

    def reload
      self.load(key)
    end

    def load(key)
      self.build(bucket.get(key).data)
      self
    end

    def arguments_to_attributes(*args)
      Hash[args.each_with_index.map { |arg, i| [riik_attributes[i], arg] }]
    end

    def build(attributes) 
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end
  end
end
