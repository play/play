require 'fileutils'

module Play
  class Album < ActiveRecord::Base
    has_many :songs
    belongs_to :artist

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

    def zipped!
      return if File.exist?(zip_path)
      FileUtils.mkdir_p "/tmp/play"
      system "zip #{zip_path} #{path}/*"
    end

    def zip_name
      "#{artist.name} - #{name}.zip".gsub(' ','\ ')
    end

    def zip_path
      "/tmp/play/#{zip_name}"
    end
  end
end
