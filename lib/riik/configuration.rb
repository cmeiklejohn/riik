module Riik

  # Configuration provides functions necessary to configuring the Riik
  # object, it's attributes and the dynamic assignment of attributes
  # during initialization.
  #
  module Configuration

    # Stores a list of the attributes that should be dynamically
    # assigned on initialization.
    #
    # @private
    #
    attr_accessor :riik_attributes

    # Defines an initializer for the including class.  
    # 
    # ```ruby
    # initializes_with :first_name, :last_name 
    # ```
    #
    #  Defines an initialize method taking two arguments, and two
    #  attr_accessors for first_name and last_name.  Assigns them on
    #  object creation.
    #
    # @param [Array] arugment list for the initializer as symbols
    #
    def initializes_with(*args)
      @riik_attributes = args

      args.each do |arg|
        attr_accessor arg.to_sym
      end
    end 

  end
end
