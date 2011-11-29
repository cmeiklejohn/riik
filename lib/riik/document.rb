module Riik
  module Document
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :riik_attributes

      def property(attribute)
        @riik_attributes ||= []
        @riik_attributes << attribute

        attr_accessor attribute
      end
    end

    def riik_attributes
      self.class.riik_attributes
    end
  end
end
