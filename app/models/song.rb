require 'time'

module Play
  class Song

    # The persistent ID of the song in the player's database.
    attr_accessor :id

    # The song's title. We use `name` as a stand-in for `title` to stay
    # consistent with Artist and Album names.
    attr_accessor :name

    # The song's String artist value.
    attr_accessor :artist

    # The song's String album value.
    attr_accessor :album

    # The song's Boolean starred value. Is this song starred? This is a special
    # attribute since it's usually never populated or accessed until directly
    # before serving as JSON, in which this attribute is populated by whether
    # the current_user has starred this song.
    attr_accessor :starred

    # The last time a song was played
    attr_accessor :last_played

    # Initializes a new Song.
    #
    # attributes = Hash containing song attributes.
    #
    # Returns a new Song instance.
    def initialize(attributes)
      @id     = attributes[:id]
      @name   = attributes[:name]
      @artist = attributes[:artist]
      @album  = attributes[:album]
      @last_played = attributes[:last_played]
    end

    # Finds a song in the database.
    #
    # id - The persistent String ID in the player's database.
    #
    # Returns an instance of a Song.
    def self.find(id)
      attributes = `osascript -e 'tell application "iTunes" to get {persistent id, name, album, artist, duration} of (get first track whose persistent ID is \"#{id}\")'`.chomp.split(", ")
      keys = [:id, :name, :album, :artist, :duration]
      if !attributes.empty?
        song = {}
        keys.each_with_index do |k,i|
          song[k] = process_value(attributes[i])
        end

        last_played = `osascript -e 'tell application "iTunes" to get played date of (get first track whose persistent ID is \"#{id}\")'`.chomp
        last_played = process_value(last_played)
        if last_played != nil
          last_played.slice!(0, 5)
          song[:last_played] = last_played
        end

        Song.new(song)
      end
    end

    # Find the most popular song by its name. Compares against playcount and
    # gets the greatest.
    #
    # Returns a Song.
    def self.find_by_name(name)
      songs = `osascript -e 'tell application "iTunes" to get persistent ID of every track whose name is \"#{name}\"'`.chomp.split(", ")
      if songs.empty?
        return nil
      end

      top = songs.sort do |a, b|
        History.count_by_song(Song.find(b)) <=> History.count_by_song(Song.find(a))
      end

      if top.first
        find(top.first)
      end
    end

    # The raw data of the album art provided for this song.
    #
    # Returns String of jpeg binary data as hex (high nimble bit first) string.
    def album_art_data
      image_data = `osascript -e 'tell application "iTunes" to get raw data of artwork 1 of (get first track whose persistent ID is "#{self.id}")' 2>&1`.chomp
      if $? == 0
        image_data.slice!(0, 10)
        image_data.chop!
        [image_data].pack('H*')
      else
        nil
      end
    end

    # The playcount for this song.
    #
    # Returns an Integer.
    def playcount
      History.count_by_song(self)
    end

    # The ID tells the tale.
    #
    # Returns a Boolean, duh.
    def ==(song)
      self.id == song.id
    end

    # Is this song queued up to play?
    #
    # Returns a Boolean.
    def queued?
      Play::Queue.queued?(self)
    end

    # The path on disk to this song.
    #
    # Returns a String.
    def path
      `osascript -e 'tell application "iTunes" to get POSIX path of (get location of first track whose persistent ID is \"#{self.id}\")'`.chomp
    end

    def last_played
      return @last_played ||= History.song_last_played_at(self)
    end

    def last_played_iso8601
      if last_played
        Time.parse(last_played).iso8601
      else
        nil
      end
    end

    # The hashed representation of a Song, suitable for API responses.
    #
    # Returns a Hash.
    def to_hash
      {
        :id      => id,
        :name    => name,
        :artist  => artist,
        :album   => album,
        :starred => starred || false,
        :queued  => queued?,
        :last_played => last_played_iso8601,
      }
    end

    # Convert applescript missing value to nils.
    #
    # Value - string applescript property.
    #
    # Returns value or nil.
    def self.process_value(value)
      value == "missing value" ? nil : value
    end

  end
end
