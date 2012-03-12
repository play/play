module Play
  class Airfoil

    # Get appscript handle for airfoil.
    #
    # Returns an Appscript instance of the airfoil app.
    def self.app
      Appscript.app('Airfoil')
    end

    # Check if Airfoil is installed.
    #
    # Returns Boolean.
    def self.installed?
      Dir.exists?('/Applications/Airfoil.app')
    end

    # Get all the connected speakers.
    #
    # This can't be named simply speakers because Airfoil
    # has a speakers method.
    #
    # Returns Array of Speakers.
    def self.get_speakers
      app.speakers.id_.get.map { |id|
        Speaker.new id
      }
    end

    # Get volume for all speakers.
    #
    # Returns Array of Floats speaker volumefrom 0.0 to 1.0.
    def self.speakers_volume
      app.speakers.volume.get
    end

    # Set the volume for all speakers.
    #
    # setting - Float 0.0 to 1.0 volume level.
    #
    # Returns Float volume level.
    def self.speakers_volume=(setting)
      app.speakers.volume.set setting
      speakers_volume
    end

  end
end
