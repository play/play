ENV["RAILS_ENV"] = ENV["RACK_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
require File.expand_path("../api_helper", __FILE__)

TEST_CONFIG_ROOT = File.join(Rails.root, 'test', 'tmp', 'play-test')

# Set up our test mpd environment
system "rm -rf   '#{TEST_CONFIG_ROOT}'"
system "mkdir -p '#{TEST_CONFIG_ROOT}'"
system "mkdir -p '#{TEST_CONFIG_ROOT + '/mpd'}'"
system "cp -R     test/music '#{File.join(TEST_CONFIG_ROOT, 'music')}'"

class ActiveSupport::TestCase
  include Rack::Test::Methods

  ActiveRecord::Migration.check_pending!
end

class ActionController::TestCase
  def sign_in(user)
    session[:github_login] = user.login
  end
end

def app
  Play::Application
end

class Channel
  def config_directory
    File.join(Rails.root, 'test', 'tmp', 'play-test', 'channels', "channel-#{id}")
  end
end

module Play

  def self.music_path
    File.join(TEST_CONFIG_ROOT, 'music')
  end

  def self.global_mpd_config_path
    File.join(TEST_CONFIG_ROOT, 'mpd')
  end

  def self.config
    @config ||= begin
      config = YAML::load(File.open('config/play.yml'))
      config['mpd']['system_audio'] = false
      config
    end
  end


  class Speaker
    def request(path, method='GET', params={})
      {:now_playing => nil, :volume => 85}
    end
  end

end

# ensure we have a channel created
if defined?(Channel) && !Channel.first
  Channel.create(:name => 'Play')
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
      Play.clear_queues
      Play.stop_servers

      define_method(:setup) { self.class.setups.each { |s| instance_eval(&s) } }
      setups << block
    end
    def self.setups; @setups ||= [] end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval &block
end
