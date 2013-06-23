ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')

# Set up our test mpd instance and its "music"
system 'rm -rf   /tmp/play-test'
system 'mkdir -p /tmp/play-test/.mpd'
system 'cp -R     test/music /tmp/play-test'
system './test/daemon/start.sh'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
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
