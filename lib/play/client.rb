module Play
  class Client
    # The main event loop for an audio client. It will loop through each song
    # in the queue, unless it's paused.
    #
    # Returns nothing.
    def self.loop
      while true
        ActiveRecord::Base.connection.reconnect!

        Signal.trap("INT") { exit! }

        if paused?
          sleep(1)
        else
          play(Song.play_next_in_queue.path)
        end
      end
    end

    # Have the client play a song
    #
    # Returns nothing
    def self.play(song_path)
    end

    # Cause the client to play the next song.
    #
    # Returns true if successful, else false.
    def self.next
      pause && pause
    end

    # "Pauses" a client by stopping currently playing songs
    #
    # Returns nothing.
    def self.pause
    end

    # Are we currently paused?
    #
    # Returns the Boolean value of whether we're paused.
    def self.paused?
      return true
    end

    # Are we currently playing? Look at the process list and check it out.
    #
    # Returns true if we're playing, false if we aren't.
    def self.playing?
      return false
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `ps ax | grep "bin/play" | grep -v grep`.split("\n").size.times do
        `kill -9 $(ps ax | grep "bin/play" | grep -v grep | cut -d ' ' -f 1)`
      end
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
    end

    # Set the volume level of the client.
    #
    #   number - The Integer volume level. This should be a number between 0
    #            and 100, with "0" being "muted" and "100" being "real real loud"
    #
    # Returns nothing.
    def self.volume=(number)
    end


    # Gets the current volume.
    #
    # Returns an Integer from 0 to 100.
    def self.volume
      0
    end
  end
end
