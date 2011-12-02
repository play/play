require File.expand_path(File.dirname(__FILE__) + '/rdio/om')
require File.expand_path(File.dirname(__FILE__) + '/rdio/client')
require File.expand_path(File.dirname(__FILE__) + '/rdio/auth')

module Play
  module Rdio
    class Library < Play::Library::Base
      def initialize
        super
        @client = Client.connection
        browser = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
        @command = browser.gsub(' ', '\ ') if File.exists?(browser)
      end
      
      def launch_url
        "http://localhost:5050/rdio/"
      end
      
      def quit_browser(track_id)
        Play::Client.kill_each("#{launch_url}#{track_id}")
      end
      
      def launch_browser(track_id)
        return nil unless @command
        return nil unless Play::Client.ps_count?("unicorn worker") && Play::Client.ps_count?("unicorn master")
        data_dir = "/tmp/play/chrome/#{rand(999999999)}"
        cmd = "#{@command} \"#{launch_url}#{track_id}\" --no-process-singleton-dialog --incognito --user-data-data-dir=#{data_dir}"
        `#{cmd} > /dev/null 2>&1`
      end
      
      def enabled?
        @client && @command       
      end
      
      def play!(song)
        launch_browser(song.path)
      end
      
      def stop!
        Play::Client.kill_each(launch_url)
      end
      
      def playing?
        Play::Client.ps_count?(launch_url)
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
        
        fetch_playlists_keys.each do |key|
          tracks = fetch_playlist_tracks(key)
          break if tracks.empty?
          
          tracks.each do |track|
            import_track(track)
          end
        end

      end
      
      def fetch_playlists_keys
        params = {}
        playlists = @client.call("getPlaylists", params)["result"] || []
        out = []
        ["collab", "subscribed", "owned"].each do |type|
          next unless playlists[type]
          playlists[type].each do |list|
            out << list["key"] if list["key"]
          end
        end
        out
      end

      def fetch_playlist_tracks(playlist_key)
        params = {}
        params["keys"] = playlist_key
        params["extras"] = "trackKeys"
        list = @client.call("get", params)["result"] || {}
        
        
        return [] unless list[playlist_key]
        return [] unless list[playlist_key]["trackKeys"]
        
        out = []
        params = {}
        
        params["keys"] = list[playlist_key]["trackKeys"].join(",")
        tracks = @client.call("get", params)["result"] || {}
        tracks.values   
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