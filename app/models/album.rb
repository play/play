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
  rescue NoMethodError => e
    @name   = '(n/a)'
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

  def client
    Play.client
  end

  def art
    songs.first.art_file if songs.first
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

  # Is this Album basically the same thing as another Album?
  #
  # Returns a Boolean.
  def ==(other)
    return false if other.class != self.class
    name == other.name && artist.name == other.artist.name
  end

  def to_param
    name
  end
end
