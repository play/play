module Play
  module Rdio
    class Auth
      def self.instructions
        config = YAML::load(File.open("config/play.yml"))
        if !config["rdio"] || !config["rdio"]["client_key"] || !config["rdio"]["client_secret"]
          raise "Please set up rdio in play.yml with client_key and client_secret"
        end
      
        # create an instance of the Rdio object with our consumer credentials
        rdio = Client.new([config["rdio"]["client_key"], config["rdio"]["client_secret"]])

        # authenticate against the Rdio service
        url = rdio.begin_authentication('oob')
        puts "Go to... " + url
        print 'Then enter the code: '
        verifier = STDIN.gets.strip
        rdio.complete_authentication(verifier)
      
        if rdio.token
          params = {}
          params["domain"] = config["domain"] if config["domain"]
          playback = rdio.call('getPlaybackToken', params)['result']
          
          puts "consumer_token for your yml file: #{rdio.token}"
          puts "playback_token for your yml file: #{playback}"
      
          puts "Let's see if it worked:"
          # find out what playlists you created
          playlists = rdio.call('getPlaylists')['result']['owned']

          # list them
          playlists.each { |playlist| puts "%s\t%s" % [playlist['shortUrl'], playlist['name']] }
        end
      end
    end
  end
end