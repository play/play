module Play
  module Local
    class Library < Play::Library::Base
      def initialize
        super
        @command = "afplay" if system("which afplay > /dev/null")
        # TODO: could support other systems in this way
      end
      
      def enabled?
        !!@command
      end
      
      def play!(song)
        system(@command, song.path)
      end
      
      def stop!
        return unless @command
        `killall #{@command} > /dev/null 2>&1`
      end
      
      def playing?
        Play::Client.ps_count?(@command)
      end
      
      def import
        self.class.import_songs
      end
      
      def monitor
        self.class.monitor_directory
      end
      
      # Monitors the music directory for any new music added to it. Once
      # changed, Play will run through and reindex those directories.
      #
      # Returns nothing.
      def self.monitor_directory
        FSSM.monitor(Play.path, '**/**/**', :directories => true) do
          update {|base, relative| import_songs("#{base}/#{relative}") }
          delete {|base, relative| nil }
          create {|base, relative| import_songs("#{base}/#{relative}") }
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

      # Imports a song into the database. This will identify a file's artist and
      # albums, run through the associations, and so on. It should be idempotent,
      # so you should be able to run it repeatedly on the same set of files and
      # not screw anything up.
      #
      #   path - the String path to the music file on-disk
      #
      # Returns the imported (or found) Song.
      def self.import_song(path)
        artist_name,title,album_name = fs_get_artist_and_title_and_album(path)
        sync_song(path, artist_name, album_name, title)
      end

      # Splits a music file up into three constituent parts: artist, title,
      # album.
      #
      #   path - the String path to the music file on-disk
      #
      # Returns an Array with three String elements: the artist, the song title,
      # and the album.
      def self.fs_get_artist_and_title_and_album(path)
        AudioInfo.open(path) do |info|
          return info.artist.try(:strip),
                 info.title.try(:strip),
                 info.album.try(:strip)
        end
      rescue AudioInfoError
      end
      
    end
  end
end