require 'pty'

module Play

  # Realtime handles pushing updates to Pusher which in turn updates the
  # play web client.
  class Realtime

    # Spawn the itunes event hook and a new thread to wait for events.
    #
    # Returns nothing.
    def self.hook
      Thread.new do
        PTY.spawn('script/itunes-hook') do |r, w, pid|
          while line = r.gets.chomp
            Player.song_changed! if line == 'song_changed'
          end
        end
      end
    end

    # Public: Sends updated now playing song and queue.
    #
    # now_playing - Song we want the web client to say is now playing.
    #
    # Returns true/false based on success.
    def self.update_now_playing(now_playing)
      song = Yajl.dump now_playing.to_hash
      Pusher["now_playing_updates"].trigger("update_now_playing", song)
    end
  end

end
