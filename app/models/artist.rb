module Play
  class Artist

    # The artist's String name.
    attr_accessor :name

    # Initializes a new Artist instance.
    #
    # name - The case-insensitive String name of the Artist.
    #
    # Returns the new Artist.
    def initialize(name)
      @name = name
    end

    # Give me all of the songs by a particular artist.
    #
    # Returns an Array of Songs.
    def songs
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track whose artist is \"#{self.name}\"'`.chomp.split(", ")
      if songs.empty?
        nil
      else
        songs.map { |id| Song.find(id) }
      end
    end

  end
end