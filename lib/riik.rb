require 'riik/version'
require 'riak'

# Riik is a lightweight object mapper for Riak.
#
#
#  Specify a class and include the object mapper mixin.  Then, specify the
#  argument list for the initialize method.
#
#  ```ruby 
#  class Person
#    include Riik::RObject
#    initializes_with :first_name, :last_name
#  end
#
#  ```
#
#  Then, use it!
#
#  ```ruby 
#  Person.find('this-key-name')  # => #<Person.. @first_name="Fat", @last_name="Mike">
#  p = Person.new('Fat', 'Mike') # => #<Person.. @first_name="Fat", @last_name="Mike">
#  p.save # => true
#  ```
module Riik
  autoload :Configuration, 'riik/configuration'
  autoload :Persistence,   'riik/persistence'
  autoload :RObject,       'riik/robject'
end
