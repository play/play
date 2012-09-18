module Play
  class Album
    # The name of the Album.
    attr_accessor :name

    # The Artist this Album points towards.
    attr_accessor :artist

    # Create a new Album.
    #
    # artist_name - The String name of the Artist.
    # name - The String name of the Album.
    #
    # Returns nothing.
    def initialize(artist_name,name)
      @artist = Artist.new(artist_name)
      @name   = name
    end

    # Get all the songs for a particular artist/album combination.
    #
    # Returns an Array of Songs.
    def songs
      results = client.search([:artist, artist.name, :album, name])
      results.map do |result|
        Song.new(artist,name_from_path(result))
      end
    end
  end
end