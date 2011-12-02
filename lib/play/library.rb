module Play
  class Library

    # Monitors the music directory for any new music added to it. Once
    # changed, Play will run through and reindex those directories.
    #
    # Returns nothing.
    def self.monitor
      FSSM.monitor(Play.path, '**/**/**', :directories => true) do
        update {|base, relative| Library.import_songs("#{base}/#{relative}") }
        delete {|base, relative| nil }
        create {|base, relative| Library.import_songs("#{base}/#{relative}") }
      end
    end

    # Search a directory and return all of the files in it, recursively.
    #
    # Returns an Array of String file paths.
    def self.fs_songs(path)
      `find "#{path}" -type f ! -name '.*'`.split("\n")
    end

    # Imports an array of songs into the database.
    #
    # path = the String path of the directory to search in. Will default to the
    #        default Play path if not specified.
    #
    # Returns nothing.
    def self.import_songs(path=Play.path)
      fs_songs(path).each do |path|
        import_song(path)
      end
    end

    # Removes an songs in the database that do not exist or are not readable
    # by AudioInfo
    #
    # Returns nothing.
    def self.prune_songs
      Song.all.each do |song|
        begin
          fs_get_song_info(song.path)
        rescue AudioInfoError
          print "'#{song.path}' is bad, removing from database.\n"
          song.destroy
        end
      end
    end

    # Imports a song into the database. This will identify a file's artist and
    # albums, run through the associations, and so on. It should be idempotent,
    # so you should be able to run it repeatedly on the same set of files and
    # not screw anything up.
    #
    #   path - the String path to the music file on-disk
    #
    # Returns the imported (or found) Song.
    def self.import_song(path)
      artist_name,title,album_name,tracknum = fs_get_song_info(path)
      song = Song.where(:path => path).first

      artist = Artist.find_or_create_by_name(artist_name)
      album = Album.find_or_create_by_name(album_name)
      if !song
        Song.create(:path => path,
                    :artist => artist,
                    :album => album,
                    :title => title,
                    :track => tracknum)
      else
        song.attributes = {:artist => artist,
                           :album => album,
                           :title => title,
                           :track => tracknum}
      end
    rescue AudioInfoError => error
      print "'#{path}' failed to import due to #{error.inspect}\n"
    end

    # Splits a music file up into three constituent parts: artist, title,
    # album.
    #
    #   path - the String path to the music file on-disk
    #
    # Returns an Array with three String elements: the artist, the song title,
    # and the album.
    def self.fs_get_song_info(path)
      AudioInfo.open(path) do |info|
        return info.artist.try(:strip),
               info.title.try(:strip),
               info.album.try(:strip),
               info.tracknum.try(:to_i)
      end
    end
  end
end
