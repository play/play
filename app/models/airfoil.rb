module Play
  class Airfoil

    # Class variable to check if Airfoil is enabled.
    @@enabled = false

    # Get enabled class variable.
    #
    # Returns Boolean.
    def self.enabled?
      @@enabled
    end

    # Set enabled class variable.
    #
    # setting - Boolean value.
    #
    # Return Boolean.
    def self.enabled=(setting)
      @@enabled = setting
    end

    # Get appscript handle for airfoil.
    #
    # Returns an Appscript instance of the airfoil app.
    def self.app
      return false if ENV['RACK_ENV'] == 'test'
      Appscript.app('Airfoil')
    end

    # Check if Airfoil is installed.
    #
    # Returns Boolean.
    def self.installed?
      File.exists?('/Applications/Airfoil.app') && ENV['RACK_ENV'] != 'test'
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

    # Get the current Airfoil audio source name.
    #
    # Returns String Airfoil audio source name.
    def self.audio_source
      app.current_audio_source.name.get
    end

    # Set audio source for Airfoil.
    #
    # setting - String application name.
    #
    # Returns String audio source name.
    def self.audio_source=(setting)
      app.application_sources.id_.get.each do |id|
        name = app.application_sources.ID(id).name.get
        if name.eql?(setting)
          app.current_audio_source.set(app.application_sources.get[id])
        end
      end
      audio_source
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
