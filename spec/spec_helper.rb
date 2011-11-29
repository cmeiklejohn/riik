# encoding: UTF-8

PROJECT_ROOT = File.expand_path("../..", __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

Bundler.require

require 'riik'

require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :webmock
  c.default_cassette_options = { :record => :none }
end

# Test class.
#
module Riik
  class Person
    include Riik::Document

    property :first
    property :last
  end
end
