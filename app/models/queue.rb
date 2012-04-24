module Play
  # Queue is a queued listing of songs waiting to be played. It's a simple
  # playlist in iTunes, which Play manicures by maintaining [queue+1] songs and
  # pruning played songs (since histories are stashed in redis).
  class Queue

    # The name of the Playlist we'll stash in iTunes.
    #
    # Returns a String.
    def self.name
      'iTunes DJ'
    end

    # The Playlist object that the Queue resides in.
    #
    # Returns an Appscript::Reference to the Playlist.
    def self.playlist
      Player.app.playlists[name].get
    end

    # Get the queue start offset for the iTunes DJ playlist.
    #
    # iTunes DJ keeps the current song in the playlist and
    # x number of songs that have played. This method returns
    # the current song index in the playlist. Using this we
    # can calculate how many songs iTunes is keeping as history.
    #
    # Example:
    #
    #   Calculate how many songs kept as history:
    #     playlist_offset - 1
    #
    #
    # Returns Integer offset to queued songs.
    def self.playlist_offset
      Player.app.current_track.index.get
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

    # Ensure that we're currently playing on the Play playlist. Don't let anyone
    # else use iTunes, because fuck 'em.
    #
    # Returns nil.
    def self.ensure_playlist
      if Play::Player.app.current_playlist.get.name.get != name
        Play::Player.app.playlists[name].get.play
      end
    rescue Exception => e
      # just in case!
    end

    # The songs currently in the Queue.
    #
    # Returns an Array of Songs.
    def self.songs
      songs = playlist.tracks.get.map do |record|
        Song.find(record.persistent_ID.get)
      end
      songs.slice(playlist_offset, songs.length - playlist_offset)
    rescue Exception => e
      # just in case!
      nil
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