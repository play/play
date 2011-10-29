require 'rubygems'
require 'rake'

#############################################################################
#
# Standard tasks
#
#############################################################################

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Custom tasks (add your own tasks here)
#
#############################################################################

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'yaml'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require 'lib/play'
  require "bundler/setup"
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/play"
end

namespace :db do
  task :create do
    config = YAML::load(File.open("#{ENV['HOME']}/.play.yml"))
    `mysql -u#{config['db']['user']} \
      --password='#{config['db']['password']}' \
      --execute=\'CREATE DATABASE #{config['db']['database']} CHARACTER SET utf8 COLLATE utf8_unicode_ci;'`
  end

  task :drop do
    config = YAML::load(File.open("#{ENV['HOME']}/.play.yml"))
    `mysql --user=#{config['db']['user']} \
           --password='#{config['db']['password']}' \
           --execute='DROP DATABASE #{config['db']['database']};'`
  end

  desc "Migrate the database through scripts in db/migrate."
  task :migrate => :environment do
    ActiveRecord::Base.establish_connection(Play.config['db'])
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
