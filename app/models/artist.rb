class Artist
  # The name of the Artist.
  attr_accessor :name

  # Create a new Artist.
  def initialize(name)
    @name = name
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

  def self.client
    Play.client
  end

  def client
    Play.client
  end

  # All of the Songs associated with this Artist.
  #
  # Returns an Array of Songs.
  def songs
    client.find([:artist, name]).map do |path|
      Song.new(path)
    end.reject{ |song| song.title.blank? }
  end

  # All of the ALbums associated with this Artist.
  #
  # Returns an Array of Albums.
  def albums
    songs.map(&:album).uniq { |album| album.name }
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

  # The slug for this artist. Escape forward slash manually here.
  #
  # Returns a String.
  def to_param
    name.gsub('/','%2F')
  end
end
