module Play
  # Queue is a queued listing of songs waiting to be played. It's a simple
  # playlist in iTunes, which Play manicures by maintaining [queue+1] songs and
  # pruning played songs (since histories are stashed in redis).
  class Queue

    # The name of the Playlist we'll stash in iTunes.
    #
    # Returns a String.
    def self.name
      'Play'
    end

    # Does the Queue exist as a playlist in iTunes?
    #
    # Returns a Boolean.
    def self.created?
      !Player.app.playlists[Appscript.its.name.eq(name)].get.empty?
    end

    # Handles all the setup for the Queue.
    #
    # Returns nothing.
    def self.setup
      if !created?
        Player.app.make(:new => :playlist, :with_properties => {:name => name})
      end
    end

    # The Playlist object that the Queue resides in.
    #
    # Returns an Appscript::Reference to the Playlist.
    def self.playlist
      setup

      Player.app.playlists[name].get
    end

    # Public: Adds a song to the Queue.
    #
    # song - A Song instance.
    #
    # Returns a Boolean of whether the song was added.
    def self.add_song(song)
      Player.app.add(song.record.location.get, :to => playlist.get)
    end

    # Public: Removes a song from the Queue.
    #
    # song - A Song instance.
    #
    # Returns a Boolean of whether the song was removed maybe.
    def self.remove_song(song)
      Play::Queue.playlist.tracks[
        Appscript.its.persistent_ID.eq(song.id)
      ].first.delete
    end

    # Clear the queue. Shit's pretty destructive.
    #
    # Returns who the fuck knows.
    def self.clear
      Play::Queue.playlist.tracks.get.each { |record| record.delete }
    end

    # The songs currently in the Queue.
    #
    # Returns an Array of Songs.
    def self.songs
      playlist.tracks.get.map do |record|
        Song.find(record.persistent_ID.get)
      end
    end

    # Is this song queued up to play?
    #
    # Returns a Boolean.
    def self.queued?(song)
      Play::Queue.playlist.tracks[
        Appscript.its.persistent_ID.eq(song.id)
      ].get.size != 0
    end

    # Returns the context of this Queue as JSON. This contains all of the songs
    # in the Queue.
    #
    # Returns an Array of Songs.
    def self.to_json
      hash = {
        :songs => songs
      }
      Yajl.dump hash
    end

  end
end