module Riik
  module Document

    # Finders provide methods to find objects in Riak.
    #
    module Finders
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        # Find an object by key.
        #
        # @return [Object] instance of the object, if found, else nil.
        #
        def find(key)
          if robject = get(key)
            self.new(robject.data).tap do |object|
              object.robject = robject
            end
          else
            nil
          end
        end

        # Get the key from Riak.
        #
        # @return [Riak::RObject] 
        # @private
        #
        def get(key)
          bucket.get(key)
        end
        private :get
      end
    end

  end
end
