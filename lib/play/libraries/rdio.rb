require File.expand_path(File.dirname(__FILE__) + '/rdio/om')
require File.expand_path(File.dirname(__FILE__) + '/rdio/client')
require File.expand_path(File.dirname(__FILE__) + '/rdio/auth')

module Play
  module Rdio
    class Library < Play::Library::Base
      def initialize
        super
      end
      
      def enabled?
        false
      end
      
      def play!(song)
        
      end
      
      def monitor
        
      end
      
      def import
        
      end
    end
  end
end