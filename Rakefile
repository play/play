require 'rubygems'
require 'rake'
require 'yaml'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/app')

require 'boot'

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
  require "bundler/setup"
end

desc "Run tests as CI sees them"
task :ci do
  ENV['CI'] = '1'
  Rake::Task['test'].invoke
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./app/boot"
end

desc "Start the server"
task :start do
  Kernel.exec "bundle exec foreman start"
end

namespace :redis do
  desc "Wipe all data in redis"
  task :reset do
    $redis.flushdb
  end
end