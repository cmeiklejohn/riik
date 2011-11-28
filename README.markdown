Riik
====

Lightweight object mapper for Riak.

Motivation
==========

Riik doesn't support everything you would exepct from a full ORM.  There
are no validations, no callbacks, and no error handling, as the primary
motivation was providing an extremely thin abstraction over RObject
allowing you to map an objects serialized fields into keys.  The
benefits come from being able to work with a lightweight abstraction
without dependencies on larger, external gems, such as activesupport and
activemodel.

If you're building an entire site with Riak as the primary data store,
you should be looking at [Ripple](https://github.com/seancribbs/ripple).

If you're looking at building a gem or Ruby application that needs to
write serialized objects directly to Riak without any overhead, look no
further.

Usage 
=====

Specify a class and include the object mapper mixin.  Then, specify the
argument list for the initialize method.

```ruby 
class Person
  include Riik::Document
  initializes_with :first_name, :last_name
end

```

Then, use it!

```ruby 
Person.find('this-key-name')  # => #<Person.. @first_name="Fat", @last_name="Mike">
p = Person.new('Fat', 'Mike') # => #<Person.. @first_name="Fat", @last_name="Mike">
p.save # => true
```

Customization 
=============

See ```lib/riik.rb``` for more information.

All of the model attributes are available as a Hash in ```attributes```.

Want to change the way the key is generated?  Override ```default_key``` in your
class.

```ruby 
def default_key 
  Base64::encode(attributes)
end
```

Want to change the content type?  Override ```content-type``` in your
class.

```ruby 
def content_type 
  "application/xml"
end
```

Want to change the bucket?  Override ```bucket``` in your
class.

```ruby 
def bucket
  "best-things"
end
```

Want to change the client?  Override ```client``` in your
class.

```ruby 
def client
  Riak::Client.new(:protocol => "pbc")
end
```

You can also change these attributes per instance!

License
=======

Riik is Copyright © 2011 Critical Pair.  Riik is free software, and may be redistributed under the terms specified in the LICENSE file.
