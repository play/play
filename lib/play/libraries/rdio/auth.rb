module Play
  module Rdio
    class Auth
      
      def self.instructions
        rdio = Client.connection(false)
        raise "Please set up rdio in play.yml with client_key and client_secret" unless rdio
        
        # authenticate against the Rdio service
        url = rdio.begin_authentication('oob')
        puts "Go to... " + url
        print 'Then enter the code: '
        verifier = STDIN.gets.strip
        rdio.complete_authentication(verifier)
      
        if rdio.token
          play = YAML::load(File.open("config/play.yml"))
          params = {}
          params["domain"] = play["domain"] || "localhost"
          playback = rdio.call('getPlaybackToken', params)['result']
          
          puts "consumer_token  for your yml file: #{rdio.token[0]}"
          puts "consumer_secret for your yml file: #{rdio.token[1]}"
          puts "playback_token  for your yml file: #{playback}"
      
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