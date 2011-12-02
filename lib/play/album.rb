require 'fileutils'

module Play
  class Album < ActiveRecord::Base
    has_many :songs
    has_many :artists, :through => :songs
    belongs_to :artist

    before_save :fetch_art

    # Runs through all of your albums and grabs album art for them.
    #
    # Returns nothing.
    def self.fetch_art!
      puts "Grabbing art for all your albums."
      Album.find_each(:batch_size => 250) do |album|
        album.save
      end
    end

    # Fetches art for this album and sets the attribute (but doesn't save). lol
    # check it out ma, XML parsing without a library and without heavy
    # dependencies.
    #
    # Returns the found art_url String.
    def fetch_art
      key = Play.config['lastfm_key']
      return if key.blank?
      url = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo"
      xml = `curl --silent "#{url}&api_key=#{key}&artist=#{URI.escape artist.name}&album=#{URI.escape name}" | grep '<image size="extralarge">'`
      self.art_url = xml.strip.sub('<image size="extralarge">','').sub('</image>','')
    end

    # Queue up an entire ALBUM!
    #
    #   user - the User who is requesting the album to be queued
    #
    # Returns nothing.
    def enqueue!(user)
      songs.each{ |song| song.enqueue!(user) }
    end

    # The path to the album on-disk. We can figure this out by looking at a
    # song on this album, and then traversing the path up a directory. That's
    # probably good.
    #
    # Returns a String path on the filesystem.
    def path
      File.expand_path File.join(songs.first.path, '..').gsub(' ','\ ')
    end

    # Zips up an album and stashes in it a temporary directory.
    #
    # Returns nothing.
    def zipped!
      return if File.exist?(zip_path)
      FileUtils.mkdir_p "/tmp/play-zips"
      system "zip #{zip_path} #{path}/*"
    end

    # The name of the zipfile.
    #
    # Returns a String.
    def zip_name
      artist_name = ''
      if artists.count == 1
        artist_name = ' - ' + artists.first.name
      end
      "#{name}#{artist_name}.zip".gsub(' ','\ ')
    end

    # The path to the zipfile.
    #
    # Returns a String.
    def zip_path
      "/tmp/play-zips/#{zip_name}"
    end
  end
end
