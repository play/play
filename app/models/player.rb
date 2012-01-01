module Play
  class Player

    # The application we're using. iTunes, dummy.
    #
    # Returns an Appscript instance of the music app.
    def self.app
      Appscript.app('iTunes')
    end

    # All longs in the library.
    def self.library
      app.playlists['Library'].get
    end

    # Play the music.
    def self.play
      app.play
    end

    # Pause the music.
    def self.pause
      app.pause
    end

    # Is there music currently playing?
    def self.paused?
      state = app.player_state.get
      state == :paused
    end

    # Maybe today is the day the music stopped.
    def self.stop
      app.stop
    end

    # Play the next song.
    def self.play_next
      app.next_track
    end

    # Play the previous song.
    def self.play_previous
      app.previous_track
    end

    # Currently-playing song.
    #
    # Returns a Song.
    def self.now_playing
      Song.new(app.current_track.persistent_ID.get)
    end

    # Search all songs for a given song title.
    #
    # keyword - The String keyword to search for.
    #
    # Returns an Array of matching Songs.
    def self.search(keyword)
      library.search(:for => keyword).map do |record|
        Song.new(record.persistent_ID.get)
      end
    end

  end
end