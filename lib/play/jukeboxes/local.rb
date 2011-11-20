module Play
  module Local
    class Jukebox < Play::Jukebox::Base
      def initialize
        super
        @command = "afplay" if system("which afplay")
        # TODO: could support other systems in this way
      end
      
      def enabled?
        !!@command
      end
      
      def play!(song)
        system(@command, song.path)
      end
      
    end
  end
end