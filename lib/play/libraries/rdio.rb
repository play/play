require File.expand_path(File.dirname(__FILE__) + '/rdio/om')
require File.expand_path(File.dirname(__FILE__) + '/rdio/client')
require File.expand_path(File.dirname(__FILE__) + '/rdio/server')
require File.expand_path(File.dirname(__FILE__) + '/rdio/auth')

module Play
  module Rdio
    class Library < Play::Library::Base
      def initialize
        super
        @client = Client.connection
      end
      
      def enabled?
        !!@client
      end
      
      def play!(song)
        @client.queue_track(song.path)
      end
      
      def stop!
        @client.stop_server
      end
      
      def playing?
        @client.playing?
      end
      
      def monitor
        # sync every ten minutes
        i = 0
        while true
          Signal.trap("INT") { exit! }  
          
          if (i % 600) != 0
            sleep(1)
          else
            i = 0
            sync_tracks
          end
          i += 1
        end
      end
      
      def import
        sync_tracks
      end

      def import_track(hash)
        artist_name = hash["albumArtist"]
        title = hash["name"]
        album_name = hash["album"]
        track_key = hash["key"]

        return unless track_key
        return unless hash["canStream"]
        
        self.class.sync_song(track_key, artist_name, album_name, title)
      end

      def sync_tracks
        page = 0
        while true
          tracks = fetch_tracks(page)
          break if tracks.empty?
          
          tracks.each do |track|
            import_track(track)
          end

          page += 1
        end
      end

      def fetch_tracks(page)
        # page starts at zero
        per_page = 15
        params = {}
        params["start"] = per_page*page
        params["count"] = per_page
        
        @client.call("getTracksInCollection", params)["result"] || []
      end
    end
  end
end