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

def app
  Play::App
end

module Play
  def self.music_path
    'test/music'
  end

  module Views
    class Layout
      def current_login
        'holman'
      end  
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