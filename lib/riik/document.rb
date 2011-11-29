module Riik
  module Document
    autoload :Persistence, 'riik/document/persistence'

    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, Persistence
    end

    module ClassMethods
      attr_accessor :riik_attributes

      def property(attribute)
        @riik_attributes ||= []
        @riik_attributes << attribute

        attr_accessor attribute
      end
    end

    def initialize(attributes = {})
      attributes.each do |key, value|
        if riik_attributes.include?(key)
          instance_variable_set "@#{key}", value
        end
      end
    end

    def riik_attributes
      self.class.riik_attributes
    end
  end
end
