class PlayQueue
  # Add a song to the end of the Queue.
  #
  # song - The Song instance to add to the Queue.
  # user - The User that requested this song (can be nil if auto-played).
  #
  # Returns the Queue.
  def self.add(song,user)
    client.add(song.path)
    user.play!(song) if user
    songs
  end

  # Finds all the songs in the queue that we're looking for and removes
  # them.
  #
  # song - The Song instance to remove from the Queue.
  #
  # Returns the Queue.
  def self.remove(song,user)
    positions = []
    songs.each_with_index do |queued_song, i|
      positions << (i+1) if song.path == queued_song.path
    end

    positions.each { |position| client.remove(position) }

    songs
  end

  # Get the current playing song
  #
  # Returns the current Song.
  def self.now_playing
    if path = client.now_playing
      Song.new(path)
    end
  end

  # Clears the queue.
  #
  # Returns nothing.
  def self.clear
    Client.new.clear
  end

  # List all of the songs in the Queue.
  #
  # Returns an Array of Songs.
  def self.songs
    results = Play.client.playlist
    results.map do |path|
      Song.new(path)
    end
  end
end