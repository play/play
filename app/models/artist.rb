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
      Player.app.tracks[Appscript.its.artist.contains(name)].get.map do |song|
        Song.new(song.persistent_ID.get)
      end
    end

  end
end