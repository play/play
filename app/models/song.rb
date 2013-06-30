require "base64"
require "digest"

class Song
  extend Machinist::Machinable if Rails.env.test?

  # The title of the Song.
  attr_accessor :title

  # The Artist this Song belongs to.
  attr_accessor :artist

  # The Album this Song belongs to.
  attr_accessor :album

  # The String file path.
  attr_reader :path

  # The duration of the song in seconds.
  attr_accessor :seconds

  # Create a new Song.
  #
  # path - The String path to the Song on disk.
  #
  # Returns nothing.
  def initialize(options={})
    self.path = options[:path] if options[:path]
  end

  # Sets the path for this Song. Once the path is set, go in and read the file
  # from disk and intialize those values in-memory.
  #
  # path - The String path on disk of the music file.
  #
  # Returns the path.
  def path=(path)
    @path = path.chomp

    TagLib::FileRef.open(full_path) do |file|
      if tag = file.tag
        @artist  = Artist.new(:name => tag.artist)
        @album   = Album.new(:artist => @artist, :name => tag.album)
        @title   = tag.title
        @seconds = file.audio_properties.length
      end
    end

    @path
  end

  # Searches for matching Songs.
  #
  # conditions - An Array of options to search on.
  # options    - A Hash of options, like `current_page`, for pagination.
  #
  # Examples
  #
  #   find(:any,   'Justice')
  #   find(:title, 'Stress')
  #   find(:album, 'Cross')
  #
  # Returns a WillPaginate::Collection of Songs.
  def self.find(conditions, options={})
    per_page     = 25
    current_page = options[:current_page] || 1
    index        = (current_page.to_i * per_page) - per_page

    results = ActiveSupport::Notifications.instrument("search.mpd", :options => options) do
      Play.mpd.search(conditions.first, conditions.second, :case_sensitive => false)
    end

    total_results = results.count
    results = results[index..index+per_page-1]

    WillPaginate::Collection.create(current_page, per_page, total_results) do |pager|
      return pager.replace([]) if !results

      results = results.map { |result| Song.new(:path => result.file) }.
        reject { |song| song.title.blank? }
      pager.replace(results)
    end
  end

  # What's currently playing?
  #
  # Returns a Song.
  def self.now_playing
    path = Play.mpd.current_song.try(:file)
    new(:path => path) if path
  end

  # The name of the artist of this song.
  #
  # Returns a String
  def artist_name
    artist ? artist.name : ''
  end

  # The name of the album of this song.
  #
  # Returns a String
  def album_name
    album ? album.name : ''
  end

  # The duration of the song.
  #
  # Returns a String.
  def duration
    return unless seconds

    m = seconds / 60
    s = sprintf('%02d', (seconds % 60))

    "#{m}:#{s}"
  end

  # Is this song currently queued up?
  #
  # Returns a Boolean.
  def queued?
    PlayQueue.songs.include?(self)
  end

  # Get the file name for the songs cached album art image.
  #
  # Returns String of the art file name.
  def art_file
    "#{Digest::SHA1.hexdigest("#{artist_name}/#{album_name}")}.png"
  end

  # The full absolute path to the song.
  #
  # Returns a String.
  def full_path
    if path[0] == '/'
      path
    else
      File.join(Play.music_path,path)
    end
  end

  # Cache a songs album art.
  #
  # Stores a cache of the album art data to Play.album_art_cache_path
  # so we don't have to shell out for every song to get the album art.
  #
  # Returns the String path if we've written new art.
  def cache_album_art
    FileUtils.mkdir_p(Play.album_art_cache_path)
    art_cache_path = "#{Play.album_art_cache_path}/#{art_file}"

    if !File.exists?(art_cache_path)
      if data = album_art_data
        File.open(art_cache_path, 'wb') { |file| file.write(data) }
        art_cache_path
      end
    end
  end

  def album_art_data
    extension = File.extname(path)

    if extension == '.m4a'
      art = TagLib::MP4::File.new(full_path).tag.item_list_map['covr'].try(:to_cover_art_list).try(:first).try(:data)
    elsif extension == '.mp3'
      frame = TagLib::MPEG::File.new(full_path).id3v2_tag.frame_list('APIC').first.try(:picture)
    end
  end

  # Is this Song basically the same thing as another Song?
  #
  # Returns a Boolean.
  def ==(other)
    return false if other.class != self.class
    path == other.path
  end

  # The people who like this song.
  #
  # Returns an Array of Users.
  def likes
    Like.where(:song_path => path)
  end

  # The plays of this Song.
  #
  # Returns an Array of SongPlays.
  def song_plays
    SongPlay.where(:song_path => path)
  end
  alias :plays :song_plays

  # The slug for this song. Escape forward slash manually here.
  #
  # Returns a String.
  def to_param
    title.gsub('/','%2F')
  end
end
