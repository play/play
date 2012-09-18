module Play
  class Song
    # The name of the Song.
    attr_accessor :name

    # The Artist this Song points towards.
    attr_accessor :artist

    # The String file path (this is usually present, but could be optional).
    attr_accessor :path

    # Create a new Song.
    #
    # artist_name - The String name of the Artist.
    # name - The String name of the Song.
    #
    # Returns nothing.
    def initialize(artist_name,name,path=nil)
      @artist = Artist.new(artist_name)
      @name   = name
      @path   = path
    end
  end
end