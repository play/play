require 'fileutils'

module Play
  class Album < ActiveRecord::Base
    has_many :songs
    belongs_to :artist

    before_save :fetch_art

    # Runs through all of your albums and grabs album art for them.
    #
    # Returns nothing.
    def self.fetch_art!
      puts "Grabbing art for all #{count} of your albums."
      Album.find_each(:batch_size => 250) do |album|
        next unless album.art_url.nil?
        next if album.name.blank?
        next if album.artist.name.blank?

        puts "  => [#{album.id}] #{album.artist.name} - #{album.name}"
        album.save
      end
    end

    # Fetches art for this album and sets the attribute (but doesn't save). lol
    # check it out ma, XML parsing without a library and without heavy
    # dependencies.
    #
    # Returns the found art_url String.
    def fetch_art(force=false)
      return unless force or art_url.nil?
      return unless url = lastfm_url

      return if name.blank?
      return if artist.name.blank?

      xml = `curl --silent "#{url}" | grep '<image size="extralarge">'`
      self.art_url = xml.strip.sub('<image size="extralarge">','').sub('</image>','')
    end

    # LastFM album.getinfo url for this album.
    #
    # Returns a String url, or nil if lastfm is not configured.
    def lastfm_url
      key = Play.config['lastfm_key']
      return if key.blank? || name.nil?

      url = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo"
      album_name = name.sub(/(EP|\[Explicit\]| )*$/i, '')
      "#{url}&api_key=#{key}&artist=#{URI.escape artist.name}&album=#{URI.escape album_name}"
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
      File.expand_path '../', songs.first.path
    end

    # Zips up an album and stashes in it a temporary directory.
    #
    # Returns nothing.
    def zipped!
      return if File.exist?(zip_path)
      FileUtils.mkdir_p "/tmp/play-zips"
      system 'tar', '-cf', zip_path, '-C', File.expand_path('..',path), File.basename(path)
    end

    # The name of the zipfile.
    #
    # Returns a String.
    def zip_name
      "#{artist.name} - #{name}.zip"
    end

    # The path to the zipfile.
    #
    # Returns a String.
    def zip_path
      "/tmp/play-zips/#{zip_name}"
    end
  end
end
