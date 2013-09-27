class Artist
  extend Machinist::Machinable if Rails.env.test?

  # The name of the Artist.
  attr_accessor :name

  # Create a new Artist.
  #
  # options - A Hash of options.
  #
  # Returns nothing.
  def initialize(options={})
    @name = options[:name]
  end

  # Show me all the artists in our library.
  #
  # Returns an Array of Strings.
  def self.all
    artists = ActiveSupport::Notifications.instrument("list.mpd", :options => [:list, :artist]) do
      Play.library.list(:artist)
    end

    artists.sort.map do |name|
      Artist.new(:name => name)
    end
  end

  # All of the Songs associated with this Artist.
  #
  # Returns an Array of Songs.
  def songs
    records = ActiveSupport::Notifications.instrument("search.mpd", :options => [:artist, :name]) do
      records = Play.library.songs_by_artist(name)
    end

    records.map do |record|
      Song.new(record)
    end.reject{ |song| song.title.blank? }
  end

  # All of the Albums associated with this Artist.
  #
  # Returns an Array of Albums.
  def albums
    Play.library.albums(name).map do |album_name|
      Album.new(:artist => self, :name => album_name) if !album_name.blank?
    end.compact
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
    name ? name.gsub('/','%2F') : ''
  end

  # Hash representation of the artist.
  #
  # Returns a Hash.
  def to_hash
    { :name => name,
      :slug => to_param
    }
  end

end
