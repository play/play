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

    # Pull all of the songs from a given Album name.
    #
    # Returns an Array of Songs.
    def self.songs_by_name(name)
      Player.library.file_tracks[Appscript.its.album.eq(name)].get.map do |record|
        Song.new(record.persistent_ID.get)
      end
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

    # Zips up an album and stashes in it a temporary directory.
    #
    # Returns nothing.
    def zipped!
      return if File.exist?(zip_path)
      FileUtils.mkdir_p "/tmp/play-zips"
      system 'tar', '-cf', zip_path, '-C', File.expand_path('..',path), File.basename(path)
    end

    # The name of the zipfile.
    #
    # Returns a String.
    def zip_name
      "#{artist} - #{name}.zip"
    end

    # The path to the album on-disk. We can figure this out by looking at a
    # song on this album, and then traversing the path up a directory. That's
    # probably good.
    #
    # Returns a String path on the filesystem.
    def path
      File.expand_path('../', songs.first.path)
    end

    # The path to the zipfile.
    #
    # Returns a String.
    def zip_path
      "/tmp/play-zips/#{zip_name}"
    end
  end
end