module Play
  class Song
    # The title of the Song.
    attr_accessor :title

    # The Artist this Song belongs to.
    attr_accessor :artist

    # The Album this Song belongs to.
    attr_accessor :album

    # The String file path.
    attr_accessor :path

    # Create a new Song.
    #
    # path - The String path to the Song on disk.
    #
    # Returns nothing.
    def initialize(path)
      path.chomp!

      full_path = File.join(Play.music_path,path)

      TagLib::FileRef.open(full_path) do |file|
        if tag = file.tag
          @artist = Artist.new(tag.artist)
          @album  = Album.new(tag.artist, tag.album)
          @title  = tag.title
        end
        @path   = path
      end
    end

    # Searches for matching Songs.
    #
    # options - An Array of mpc-friendly options to search on.
    #
    # Examples
    #
    #   find(:any,   'Justice')
    #   find(:title, 'Stress')
    #   find(:album, 'Cross')
    #
    # Returns an Array of Songs.
    def self.find(options)
      results = client.search(options)
      results.map {|path| Song.new(path) }
    end

    # The name of the artist of this song.
    #
    # Returns a String
    def artist_name
      artist.name
    end

    # The name of the album of this song.
    #
    # Returns a String
    def album_name
      album.name
    end

    # Is this Song basically the same thing as another Song?
    #
    # Returns a Boolean.
    def ==(other)
      return false if other.class != self.class
      title == other.title
    end
  end
end
