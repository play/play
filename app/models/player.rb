module Play
  class Player

    # Play the music.
    def self.play
      `osascript -e 'tell application "iTunes" to play'`
    end

    # Pause the music.
    def self.pause
      `osascript -e 'tell application "iTunes" to pause'`
    end

    # Get current state.
    #
    # Returns symbol.
    def self.state
      `osascript -e 'tell application "iTunes" to get player state'`.chomp.to_sym
    end

    # Is there music currently playing?
    def self.paused?
      state == :paused
    end

    # Maybe today is the day the music stopped.
    def self.stop
      `osascript -e 'tell application "iTunes" to stop'`
    end

    # Play the next song.
    #
    # Returns the new song.
    def self.play_next
      `osascript -e 'tell application "iTunes" to play next track'`
      now_playing
    end

    # Play the previous song.
    #
    # Returns the new song.
    def self.play_previous
      `osascript -e 'tell application "iTunes" to play previous track'`
      now_playing
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
      `osascript -e 'tell application "iTunes" to get sound volume'`.chomp.to_i
    end

    # Set the app volume.
    #
    # setting - An Integer value between 0-100, where 100% is loud and, well, 0
    #           is for losers in offices that are boring.
    #
    # Returns the current volume setting.
    def self.app_volume=(setting)
      `osascript -e 'tell application "iTunes" to set sound volume to #{setting}'`
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

    # Get persistent id of current track.
    #
    # Returns string.
    def self.current_track
      `osascript -e 'tell application "iTunes" to get persistent ID of current track'`.chomp
    end

    # Currently-playing song.
    #
    # Returns a Song.
    def self.now_playing
      if state == :playing
        Song.find(current_track)
      else
        nil
      end
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
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track whose artist is \"#{keyword}\"' 2>&1`.chomp.split(", ")
      if $? == 0 && !songs.empty?
        return songs.map { |id| Song.find(id) }
      end

      # Exact Album match.
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track whose album is \"#{keyword}\"' 2>&1`.chomp.split(", ")
      if $? == 0 && !songs.empty?
        return songs.map { |id| Song.find(id) }
      end

      # Exact Song match.
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track whose name is \"#{keyword}\"' 2>&1`.chomp.split(", ")
      if $? == 0 && !songs.empty?
        return songs.map { |id| Song.find(id) }
      end

      # Fuzzy Song match.
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track whose name contains \"#{keyword}\"' 2>&1`.chomp.split(", ")
      if $? == 0 && !songs.empty?
        return songs.map { |id| Song.find(id) }
      end
    end

  end
end