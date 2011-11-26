module Riik
  module Configuration
    attr_accessor :riik_attributes

    def initializes_with(*args)
      @riik_attributes = args

      args.each do |arg|
        attr_accessor arg.to_sym
      end
    end 
  end
end
