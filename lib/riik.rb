require 'riik/version'

module Riik
  module RObject

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :riik_attributes

      def initializes_with(*args)
        @riik_attributes = args

        args.each do |arg|
          attr_accessor arg.to_sym
        end
      end
    end

    def initialize(*args)
      args.each_with_index do |arg, i|
        attribute = self.class.riik_attributes[i]
        instance_variable_set "@#{attribute}", arg
      end
    end

  end
end
