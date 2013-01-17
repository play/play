require "base64"
require "digest"

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

      if path[0] == '/'
        full_path = path
      else
        full_path = File.join(Play.music_path,path)
      end

      TagLib::FileRef.open(full_path) do |file|
        if tag = file.tag
          @artist = Artist.new(tag.artist)
          @album  = Album.new(tag.artist, tag.album)
          @title  = tag.title
        end
        @path   = path
      end
    end

    # Searches for matching Songs.
    #
    # options - An Array of mpc-friendly options to search on.
    #
    # Examples
    #
    #   find(:any,   'Justice')
    #   find(:title, 'Stress')
    #   find(:album, 'Cross')
    #
    # Returns an Array of Songs. Maxes out at a hard fifty... deal with it.
    def self.find(options)
      results = client.search(options)[0..50]
      results.map {|path| Song.new(path) }
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

    # The duration of the song in seconds.
    #
    # Returns an Integer.
    def duration
      string = `mediainfo "#{Play.music_path}/#{path}" -f | grep Duration | head -n 5 | tail -n 1`
      array = string.split(':')
      "#{array[2]}:#{array[3].split('.').first}" if array[3]
    end

    # Is this song currently queued up?
    #
    # Returns a Boolean.
    def queued?
      Queue.songs.include?(self)
    end

    # The album art.
    #
    # Returns a String of binary data.
    def art
      output = `mediainfo "#{Play.music_path}/#{path}" -f | grep Cover_Data`
      data = output.split(':').last
      data ? Base64.decode64(data.chomp) : nil
    end

    # Get the file name for the songs cached album art image.
    #
    # Returns String of the art file name.
    def art_file
      "#{Digest::SHA1.hexdigest("#{artist_name}/#{album_name}")}.png"
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
        if !art.nil?
          File.write(art_cache_path, art, mode: 'wb')
          art_cache_path
        end
      end
    end

    # Is this Song basically the same thing as another Song?
    #
    # Returns a Boolean.
    def ==(other)
      return false if other.class != self.class
      path == other.path
    end
  end
end