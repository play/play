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
      results.map do |path|
        Song.new(path)
      end
    end

    # The path to the zipfile.
    #
    # Returns a String.
    def zip_path
      "/tmp/play-zips/#{zip_name}"
    end

    # The name of the zipfile.
    #
    # Returns a String.
    def zip_name
      "#{artist.name} - #{name}.zip"
    end

    # The path to the zipped file on-disk. Compresses this album if we haven't 
    # yet.
    #
    # Returns a String.
    def zipped(path)
      return zip_path if File.exist?(zip_path)
      FileUtils.mkdir_p "/tmp/play-zips"
      system 'zip', '-0rjq', zip_path, path

      zip_path
    end
  end
end