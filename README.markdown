# Riik

Lightweight object mapper for Riak.

## Motivation

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

## Usage 

To define a class:

```ruby
class Person
  include Riik::Document

  property :first_name
  property :last_name
end
```

To use:

```ruby
p = Person.new(:first_name => 'Fat', :last_name => 'Mike')
p.save # => true
p.destroy # => true
Person.find(p.key) # => p
```

## Contributing

1. Fork the official repository.
2. Make your changes in a topic branch (with tests, please).
3. Send a pull request.
4. Once accepted, you'll get a free limited-run Critical Pair t-shirt!

## License

Riik is Copyright © 2011 Critical Pair.  Riik is free software, and may be redistributed under the terms specified in the LICENSE file.
