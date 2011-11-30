require 'riik/version'
require 'riak'

# Riik is a lightweight object mapper for Riak.
#
# To define a class:
#
# ```ruby
# class Person
#   include Riik::Document
# 
#   property :first_name
#   property :last_name
# end
# ```
# 
# To use:
#
# ```ruby
# p = Person.new(:first_name => 'Fat', :last_name => 'Mike')
# p.save # => true
# p.destroy # => true
# Person.find(p.key) # => p
# ```
#
module Riik
  autoload :Document, 'riik/document'

  class << self
    def client=(client)
      @client = client
    end

    def client
      @client ||= Riak::Client.new
    end
  end
end
