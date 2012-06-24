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

    # Get the queue start offset for the iTunes DJ playlist.
    #
    # Bug: When player is stopped with no song, returns 0 resulting
    #      in queue including any song history from iTunes DJ.
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
      if [:playing, :paused].include?(Player.state)
        `osascript -e 'tell application "iTunes" to get index of current track'`.chomp.to_i
      else
        0
      end
    end

    # Public: Adds a song to the Queue.
    #
    # song - A Song instance.
    #
    # Returns a Boolean of whether the song was added.
    def self.add_song(song)
      `osascript -e 'tell application "iTunes" to add add (get location of first track whose persistent ID is \"#{song.id}\") to playlist \"#{name}\"'`
    end

    # Public: Removes a song from the Queue.
    #
    # song - A Song instance.
    #
    # Returns a Boolean of whether the song was removed maybe.
    def self.remove_song(song)
      `osascript -e 'tell application "iTunes" to delete (first track of playlist \"#{name}\" whose persistent ID is \"#{song.id}\")'`
    end

    # Clear the queue. Shit's pretty destructive.
    #
    # Returns nil.
    def self.clear
      `osascript -e 'tell application "iTunes" to delete (every track of playlist \"#{name}\")'`
      nil
    end

    # Ensure that we're currently playing on the Play playlist. Don't let anyone
    # else use iTunes, because fuck 'em.
    #
    # Returns nil.
    def self.ensure_playlist
      current_playlist = `osascript -e 'tell application "iTunes to get name of current playlist'`.chomp
      if current_playlist != name
        `osascript -e 'tell application "iTunes" to play playlist \"#{name}\"'`
      end
      nil
    end

    # The songs currently in the Queue.
    #
    # Returns an Array of Songs.
    def self.songs
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track of playlist \"#{name}\"'`.chomp.split(", ")
      if songs.empty?
        nil
      else
        songs.map! { |id| Song.find(id) }
        songs.slice(playlist_offset, songs.length - playlist_offset)
      end
    end

    # Is this song queued up to play?
    #
    # Returns a Boolean.
    def self.queued?(song)
      queued = `osascript -e 'tell application "iTunes" to get exists (first track of playlist \"#{name}\" whose persistent ID is \"#{song.id}\")'`.chomp.to_sym
      queued == :true
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