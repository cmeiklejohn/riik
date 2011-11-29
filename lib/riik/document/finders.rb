module Riik
  module Document
    module Finders
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def find(key)
          if robject = get(key)
            self.new(robject.data).tap do |object|
              object.robject = robject
            end
          else
            nil
          end
        end

        def get(key)
          bucket.get(key)
        end
      end
    end
  end
end
