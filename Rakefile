require 'rubygems'
require 'rake'
require 'yaml'
require 'sinatra/activerecord/rake'
require './app/play'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/app')

task :default do
  ENV['RACK_ENV'] = 'test'
  Rake::Task['test'].invoke
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :environment do
  require 'lib/play'
  require 'bundler/setup'
end

namespace :db do
  # TODO: hook into config/database.yml
  task :create do
    `mysql \
      --user="root" \
      --password="" \
      --execute='CREATE DATABASE IF NOT EXISTS play CHARACTER SET utf8 COLLATE utf8_unicode_ci;'`
  end
end

Kernel.trap("EXIT") do
  system './test/daemon/stop.sh'
end