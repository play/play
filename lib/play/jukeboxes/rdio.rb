require File.expand_path(File.dirname(__FILE__) + '/rdio/om')
require File.expand_path(File.dirname(__FILE__) + '/rdio/client')
require File.expand_path(File.dirname(__FILE__) + '/rdio/auth')

module Play
  module Rdio
    class Jukebox < Play::Jukebox::Base
      def initialize
        super
      end
      
      def enabled?
        false
      end
      
      def play!(song)
        
      end   
    end
  end
end