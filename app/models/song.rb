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

  # Placeholder for setting if the song is liked by the current user.
  attr_accessor :liked

  # Create a new Song.
  #
  # path - The String path to the Song on disk.
  #
  def self.from_path(path)
    song = Play.library.songs(path).first
    new(song)
  end

  # Create a new Song.
  #
  # mpd_song - The MPD::Song object representing the song.
  #
  # Returns nothing.
  def initialize(mpd_song = nil)
    if mpd_song
      @path    = mpd_song.file
      @artist  = Artist.new(:name => mpd_song.artist)
      @album   = Album.new(:artist => @artist, :name => mpd_song.album)
      @title   = mpd_song.title
      @seconds = mpd_song.time
    end
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

    results = ActiveSupport::Notifications.instrument("search.mpd") do
      Play.library.search(conditions.first, conditions.second, :case_sensitive => false)
    end

    total_results = results.count
    results = results[index..index+per_page-1]

    WillPaginate::Collection.create(current_page, per_page, total_results) do |pager|
      return pager.replace([]) if !results

      results = results.map { |result| Song.new(result) }.
        reject { |song| song.title.blank? }
      pager.replace(results)
    end
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
    false
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
      tag = TagLib::MP4::File.new(full_path).tag
      tag.item_list_map['covr'].try(:to_cover_art_list).try(:first).try(:data) if tag
    elsif extension == '.mp3'
      tag = TagLib::MPEG::File.new(full_path).id3v2_tag
      tag.frame_list('APIC').first.try(:picture) if tag
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
    Like.where(:song_path => path).group(:user_id)
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
    title ? title.gsub('/','%2F') : ''
  end

  # Hash representation of the song.
  #
  # Returns a Hash.
  def to_hash
    { :title => title,
      :album_name => album.name,
      :album_slug => album.to_param,
      :artist_name => artist.name,
      :artist_slug => artist.to_param,
      :album_art_path => "/images/art/#{album.art}",
      :seconds => seconds,
      :liked => liked || false,
      :queued => queued?,
      :path => path,
      :slug => to_param
    }
  end
end
