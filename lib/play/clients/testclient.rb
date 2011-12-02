module Play
  class TestClient < Client
    # Cause the client to play a song
    #
    # Returns nothing
    def self.play(song_path)
    end

    # "Pauses" a client by stopping currently playing songs
    #
    # Returns true if client is paused successfully.
    def self.pause
      return true
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
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
    end

    # Set the volume level of the client.
    #
    #   number - The Integer volume level. This should be a number between 0
    #            and 10, with "0" being "muted" and "10" being "real real loud"
    #
    # Returns true if volume was set successfully.
    def self.volume(number)
      return true
    end
  end
end
