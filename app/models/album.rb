class Album
  extend Machinist::Machinable if Rails.env.test?

  # The name of the Album.
  attr_accessor :name

  # The Artist this Album points towards.
  attr_accessor :artist

  # Create a new Album.
  #
  # options - The Hash of options.
  #
  # Returns nothing.
  def initialize(options={})
    @artist = options[:artist]
    @name   = options[:name]
  end

  # Get all the songs for a particular artist/album combination.
  #
  # Returns an Array of Songs.
  def songs
    results = ActiveSupport::Notifications.instrument("find.mpd", :options => [:artist, artist.name, :album, name]) do
      results = Play.mpd.send_command(:find, :artist, artist.name, :album, name)
    end

    results.map do |result|
      Song.new(:path => result[:file])
    end
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

  # The slug for this album. Escape forward slash manually here.
  #
  # Returns a String.
  def to_param
    name ? name.gsub('/','%2F') : ''
  end
end
