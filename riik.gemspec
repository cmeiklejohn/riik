# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

require "riik/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Christopher Meiklejohn"]
  gem.email         = ["christopher.meiklejohn@gmail.com"]
  gem.description   = %q{Lightweight object mapper for Riak.}
  gem.summary       = %q{Lightweight object mapper for Riak.}
  gem.homepage      = "http://critialpair.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.name          = "riik"
  gem.require_paths = ["lib"]
  gem.version       = Riik::VERSION

  gem.add_dependency('riak-client')
  gem.add_dependency('excon')

  gem.add_development_dependency('yard')
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('redcarpet')

  gem.add_development_dependency('vcr')
  gem.add_development_dependency('webmock')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rake','~> 0.9.2')

  gem.add_development_dependency('guard')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('guard-yard')
  gem.add_development_dependency('guard-ctags-bundler')
end
