module Play
  module Library
    def self.klazzes
      [Play::Local::Library, Play::Rdio::Library]
    end
    
    def self.instances
      return @instances if @instances
      @instances = {}
      klazzes.each do |klazz|
        @instances[klazz.name] = klazz.new
      end
      @instances
    end
    
    def self.instance(name)
      inst = instances[name]
      # TODO: constantize and add to @instances if not there (with big fat rescue)
      inst
    end
    
    def self.enabled(&block)
      instances.values.each do |instance|
        yield instance if instance.enabled?
      end
    end
    
    class Base
      def self.sync_song(path, artist_name, album_name, title)
        artist = Artist.find_or_create_by_name(artist_name)
        song = Song.where(:path => path).first

        if !song
          album = Album.where(:artist_id => artist.id, :name => album_name).first ||
                  Album.create(:artist_id => artist.id, :name => album_name)
          song = Song.create(:path => path,
                      :artist => artist,
                      :album => album,
                      :title => title,
                      :library_type => self.name)
        end
        song
      end
      
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