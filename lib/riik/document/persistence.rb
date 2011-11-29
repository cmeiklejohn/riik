module Riik
  module Document
    module Persistence
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def create(attributes = {})
          self.new(attributes).tap do |object|
            object.save
          end
        end
      end

      def save
        robject.data = attributes
        robject.store
      end

      def destroy
        robject.delete
      end
    end
  end
end
