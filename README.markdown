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

Customization 
=============

License
=======

Riik is Copyright © 2011 Critical Pair.  Riik is free software, and may be redistributed under the terms specified in the LICENSE file.
