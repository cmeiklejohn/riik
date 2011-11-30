module Riik
  module Document

    # Persistence provides methods for creating and saving documents to
    # Riak.
    #
    module Persistence
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        # Create a new object from provided attributes.
        #
        # @return [Object] instance of created object.
        #
        def create(attributes = {})
          self.new(attributes).tap do |object|
            object.save
          end
        end
      end

      # Save the object to Riak.
      #
      # @return [Boolean]
      #
      def save
        robject.data = attributes
        robject.store
      end

      # Destroy the object in Riak.
      #
      # @return [Boolean]
      #
      def destroy
        robject.delete
      end
    end

  end
end
