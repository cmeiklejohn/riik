# encoding: UTF-8

PROJECT_ROOT = File.expand_path("../..", __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

Bundler.require

Dir[File.join(PROJECT_ROOT,"spec/support/**/*.rb")].each {|f| require f}

require 'riik'
require 'ripple'

require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

# Test class.
#
module Riik
  class Person
    include Riik::Document

    property :first_name
    property :last_name
  end
end

# Ripple configuration.
#
if ENV['TDDIUM_RIAK_HOST']
  Ripple.client = Riak::Client.new(:nodes => [
    {:host => ENV['TDDIUM_RIAK_HOST'], :http_port => ENV['TDDIUM_RIAK_HTTP_PORT']}
  ])
end
