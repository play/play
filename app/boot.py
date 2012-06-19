$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require 'logger'

require 'redis'
require 'coffee-script'
require 'sinatra/base'
require 'mustache/sinatra'
require 'sinatra_auth_github'
require 'yajl'
require 'sass'
require 'appscript' if RUBY_PLATFORM.downcase.include?("darwin") && !ENV['CI']
require 'pusher'

require 'play'

require 'models/artist'
require 'models/album'
require 'models/history'
require 'models/office'
require 'models/player'
require 'models/queue'
require 'models/song'
require 'models/user'
require 'models/speaker'
require 'models/airfoil'

require 'app'
require 'views/layout'

REDIS_URL = 'redis://127.0.0.1'
$redis = Redis.connect(:url => REDIS_URL, :thread_safe => true)

require 'open-uri'
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=
    
    def use_ssl=(flag)
      # Ubuntu
      if File.exists?('/etc/ssl/certs')
        self.ca_path = '/etc/ssl/certs'
      
      # MacPorts on OS X
      # You'll need to run: sudo port install curl-ca-bundle
      elsif File.exists?('/usr/local/play/ca_bundle.crt')
        self.ca_file = '/usr/local/play/ca_bundle.crt'
      end

      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      self.original_use_ssl = flag
    end
  end
end
