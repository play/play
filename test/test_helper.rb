ENV["RAILS_ENV"] = "test"
ENV["RACK_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
require File.expand_path("../api_helper", __FILE__)

include Rack::Test::Methods

# Set up our test mpd instance and its "music"
system 'rm -rf   /tmp/play-test'
system 'mkdir -p /tmp/play-test/.mpd'
system 'cp -R     test/music /tmp/play-test'
system './test/daemon/start.sh'

class ActiveSupport::TestCase
end

class ActionController::TestCase
  def sign_in(user)
    session[:github_login] = user.login
  end
end

def app
  Play::App
end

module Play
  def self.music_path
    'test/music'
  end
end

class Client
  # Test mpd runs on a different port (6611 instead of 6600).
  def port
    '6611'
  end
end

##
# test/spec/mini 5
# http://gist.github.com/307649
# chris@ozmm.org

def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(defined?(ActiveSupport::TestCase) ? ActiveSupport::TestCase : Test::Unit::TestCase) do
    def self.test(name, &block)
      define_method("test_#{name.to_s.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.context(*args, &block) instance_eval(&block) end
    def self.setup(&block)
      # Clear out the entire queue during each `setup` block.
      Client.new.clear

      define_method(:setup) { self.class.setups.each { |s| instance_eval(&s) } }
      setups << block
    end
    def self.setups; @setups ||= [] end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval &block
end
