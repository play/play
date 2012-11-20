$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'test/unit'
require 'rubygems'

Bundler.require(:test)
require 'spec/mini'

require 'play'
include Play
include Rack::Test::Methods

# Set up our test mpd instance and its "music"
system 'rm -rf   /tmp/play-test'
system 'mkdir -p /tmp/play-test/.mpd'
system 'cp -R     test/music /tmp/play-test'
system './test/daemon/start.sh'

# Silence logs
ActiveRecord::Base.logger = nil

# Set up db cleaning
DatabaseCleaner.strategy = :truncation

def app
  Play::App
end

module Play
  def self.music_path
    'test/music'
  end

  class App
    def current_user
      User.find_or_create_by_login('holman')
    end
  end
end

module Play
  class Client
    # Test mpd runs on a different port (6611 instead of 6600).
    def port
      '6611'
    end
  end
end