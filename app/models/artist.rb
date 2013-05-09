module Play
  class Artist
    # The name of the Artist.
    attr_accessor :name

    # Create a new Artist.
    def initialize(name)
      @name = CGI.unescape(name)
    end

    # Show me all the artists in our library.
    #
    # Returns an Array of Strings.
    def self.all
      artists = client.list(:artist)
      artists.sort.map do |name|
        Artist.new(name.chomp)
      end
    end

    # All of the Songs associated with this Artist.
    #
    # Returns an Array of Songs.
    def songs
      client.search([:artist, name]).map do |path|
        Song.new(path)
      end
    end

    # A simple String representation of this instance.
    #
    # Returns a String.
    def to_s
      "#<Play::Artist name='#{name}'>"
    end

    # Determine equivalence based on the name of an artist.
    #
    # Returns a Boolean.
    def ==(other)
      return false if other.class != self.class
      name == other.name
    end
  end
end