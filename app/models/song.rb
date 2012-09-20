module Play
  class Song
    # The title of the Song.
    attr_accessor :title

    # The Artist this Song points towards.
    attr_accessor :artist

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
        @title  = tag.title
        @path   = path
      end
    end
  end
end