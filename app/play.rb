require 'rubygems'
require 'bundler'

Bundler.setup(:default)
Bundler.require(:default)

require_relative 'models/album'
require_relative 'models/artist'
require_relative 'models/client'
require_relative 'models/helpers'
require_relative 'models/queue'
require_relative 'models/song'

require_relative 'app'
require_relative 'views/layout'

include Play::Helpers

module Play  
  def self.client
    Client.new
  end
end