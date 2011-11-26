#!/usr/bin/env rake

require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake'
require 'rdoc/task'
require 'rake/clean'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

include Rake::DSL

Bundler::GemHelper.install_tasks

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => [:spec]
