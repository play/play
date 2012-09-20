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
        tag     = file.tag

        @artist = Artist.new(tag.artist)
        @album  = Album.new(tag.artist, tag.album)
        @title  = tag.title
        @path   = path
      end
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