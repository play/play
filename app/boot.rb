$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require 'logger'
require 'tempfile'
require 'open-uri'

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

# FIX (Hack)
# Patch HTTP to use a ca_bundle.crt
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=
    
    def use_ssl=(flag)
      
      app_root = File.dirname(File.expand_path(File.dirname(__FILE__)))
      ca_file = File.join(app_root, "ca_bundle.crt")
      
      # Ubuntu
      if File.exists?('/etc/ssl/certs')
        self.ca_path = '/etc/ssl/certs'
      # MacPorts on OS X
      elsif File.exists?(ca_file)
        self.ca_file = ca_file
      end

      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      self.original_use_ssl = flag
    end
  end
end