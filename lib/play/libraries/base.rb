module Play
  module Library
    def self.klazzes
      [Play::Local::Library, Play::Rdio::Library]
    end
    
    def self.instances
      return @instances if @instances
      @instances = []
      klazzes.each do |klazz|
        @instances << klazz.new
      end
      @instances
    end
    
    def self.enabled(&block)
      instances.each do |instance|
        yield instance if instance.enabled?
      end
    end
    
    class Base
      def enabled?
        raise("Library should implement enabled?")
      end
    
      def play!(song)
        raise("Library should implement play!")
      end
      
      def monitor
        raise("Library should implement monitor")
      end
      
      def import
        raise("Library should implement import")
      end
    end
  end
end