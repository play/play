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
    # (Eventually) returns a Song.
    def self.now_playing
      title  = app.current_track.get.name.get
      artist = app.current_track.get.artist.get
      OpenStruct.new(:title => title, :artist => artist)
    end

    # Give me all of the songs by a particular artist.
    #
    # artist - The (case-insensitive) String name of an Artist.
    #
    # (Eventually) returns an Array of Songs.
    def self.songs_by_artist(artist)
      library.tracks[Appscript.its.artist.contains(artist)].get.map do |song|
        OpenStruct.new(:title => song.name.get, :artist => song.artist.get)
      end
    end

  end
end