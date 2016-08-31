require 'vlcrc'
module Play
  class Player::Vlc

    #
    def self.app
      @@vlc ||= create_new_vlc_player
    end
 

    def self.create_new_vlc_player(host = "localhost", port = 1234)
      vlc = VLCRC::VLC.new( host, port )
      vlc.launch
      until vlc.connected?
        sleep 0.1
        vlc.connect
      end
      vlc.add_media("/srv/mp3")
      vlc
    end

    # All songs in the library.
    def self.library
      app.playlist
    end

    # Play the music.
    def self.play
      app.play!
    end

    # Pause the music.
    def self.pause
      app.pause!
    end

    # Is there music currently playing?
    def self.paused?
      state = app.player_state.get
      state == :paused
    end

    # Maybe today is the day the music stopped.
    def self.stop
      app.stop!
    end

    # Play the next song.
    #
    # Returns the new song.
    def self.play_next
      app.next
      now_playing
    end

    # Play the previous song.
    def self.play_previous
      app.previous
    end

    # Get the current numeric volume.
    #
    # Returns an Integer from 0-100.
    def self.system_volume
      #TODO
    end

    # Set the system volume.
    #
    # setting - An Integer value between 0-100, where 100% is loud and, well, 0
    #           is for losers in offices that are boring.
    #
    # Returns the current volume setting.
    def self.system_volume=(setting)
      #TODO
    end

    # Get the current numeric volume.
    #
    # Returns an Integer from 0-100.
    def self.app_volume
      app.volume
    end

    # Set the app volume.
    #
    # setting - An Integer value between 0-100, where 100% is loud and, well, 0
    #           is for losers in offices that are boring.
    #
    # Returns the current volume setting.
    def self.app_volume=(setting)
      app.volume = setting
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
      #Song.new(app.current_track.persistent_ID.get)
      app.media
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
      app.search(keyword)
    end
  end
end
