module Play
  class Album

    # Name of the Album.
    attr_accessor :name

    # Name of the Artist.
    attr_accessor :artist

    # Initializes a new Album instance.
    #
    # name   - The String name of the album.
    # artist - The String name of the artist.
    #
    # Returns the new Album.
    def initialize(name,artist)
      @name   = name
      @artist = artist
    end

    # The songs attached to this album.
    #
    # Returns an Array of Songs.
    def songs
      Player.library.file_tracks[
        Appscript.its.album.eq(name).and(Appscript.its.artist.eq(artist))
      ].get.map do |record|
        Song.new(record.persistent_ID.get)
      end
    end

  end
end