$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
  require 'leftright'
rescue LoadError
end

require 'spec/mini'

require 'play'
include Play

# Set up our test mpd instance and its "music"
system 'rm -rf   /tmp/play-test'
system 'mkdir -p /tmp/play-test/.mpd'
system 'cp -R     test/music /tmp/play-test'
system './test/daemon/start.sh'

module Play
  class Client
    # Test mpd runs on a different port (6611 instead of 6600).
    def port
      '6611'
    end
  end
end