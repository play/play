module Play
  module Jukebox
    class Base
      def enabled?
        raise("Jukebox should implement enabled?")
      end
    
      def play!(song)
        raise("Jukebox should implement play!")
      end
    end
  end
end