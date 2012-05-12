module Play
  class Player

    # The application we're using. iTunes, dummy.
    #
    # Returns an Appscript instance of the music app.
    def self.app
      Appscript.app('iTunes')
    end

    # All songs in the library.
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
    #
    # Returns the new song.
    def self.play_next
      app.next_track
      now_playing
    end

    # Play the previous song.
    def self.play_previous
      app.previous_track
    end

    # Get the current numeric volume.
    #
    # Returns an Integer from 0-100.
    def self.system_volume
      `osascript -e 'get output volume of (get volume settings)'`.chomp.to_i
    end

    # Set the system volume.
    #
    # setting - An Integer value between 0-100, where 100% is loud and, well, 0
    #           is for losers in offices that are boring.
    #
    # Returns the current volume setting.
    def self.system_volume=(setting)
      `osascript -e 'set volume output volume #{setting}' 2>/dev/null`
      setting
    end

    # Get the current numeric volume.
    #
    # Returns an Integer from 0-100.
    def self.app_volume
      app.sound_volume.get
    end

    # Set the app volume.
    #
    # setting - An Integer value between 0-100, where 100% is loud and, well, 0
    #           is for losers in offices that are boring.
    #
    # Returns the current volume setting.
    def self.app_volume=(setting)
      app.sound_volume.set(setting)
      setting
    end

    # Say something. Robots can speak too, you know.
    #
    # Thirds the volume, does its thing, brings the volume up again, and
    # returns the current volume.
    def self.say(message)
      previous = self.app_volume
      self.app_volume = self.app_volume/3
      `say #{message}`
      self.app_volume = previous
    end

    # Currently-playing song.
    #
    # Returns a Song.
    def self.now_playing
      Song.new(app.current_track.persistent_ID.get)
    rescue Appscript::CommandError
      nil
    end

    # Handle song change event.
    #
    # Push song_update to web clients.
    #
    # Returns nothing.
    def self.song_changed!
      Realtime.update_now_playing(now_playing)
    end

    # Search all songs for a keyword.
    #
    # Search workflow:
    #   - Search for exact match on Artist name.
    #   - Search for exact match on Song title.
    #   - Search for fuzzy match on Song title.
    #
    # keyword - The String keyword to search for.
    #
    # Returns an Array of matching Songs.
    def self.search(keyword)
      # Exact Artist match.
      songs = library.tracks[Appscript.its.artist.eq(keyword)].get
      return songs.map{|record| Song.new(record.persistent_ID.get)} if songs.size != 0

      # Exact Album match.
      songs = library.tracks[Appscript.its.album.eq(keyword)].get
      return songs.map{|record| Song.new(record.persistent_ID.get)} if songs.size != 0

      # Exact Song match.
      songs = library.tracks[Appscript.its.name.eq(keyword)].get
      return songs.map{|record| Song.new(record.persistent_ID.get)} if songs.size != 0

      # Fuzzy Song match.
      songs = library.tracks[Appscript.its.name.contains(keyword)].get
      songs.map{|record| Song.new(record.persistent_ID.get)}
    end

  end
end