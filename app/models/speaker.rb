module Play
  class Speaker

    # The Airfoil ID for the speaker.
    attr_reader :id

    # Initialize a new speaker.
    #
    # id - Airfoil id of the speaker.
    #
    # Returns new Speaker.
    def initialize(id)
      @id = id
    end

    # Get appscript handle for airfoil.
    #
    # Returns Airfoil appscript handle.
    def app
      Airfoil.app
    end

    # Get the speaker name.
    #
    # Returns String speaker name.
    def name
      app.speakers.ID(@id).name.get
    end

    # Check if the speaker is connected to an audio source.
    #
    # Returns boolean.
    def connected?
      app.speakers.ID(@id).connected.get
    end

    # Connect the speaker to the audio source.
    #
    # Returns Boolean connected?
    def connect!
      app.speakers.ID(@id).connect_to
      connected?
    end

    # Disconnect the speaker from audio source.
    #
    # Returns Boolean connected?
    def disconnect!
      app.speakers.ID(@id).disconnect_from
      connected?
    end

    # Get volume for a specific speaker.
    #
    # Returns Float volume level from 0.0 to 1.0.
    def volume
      app.speakers.ID(@id).volume.get
    end

    # Set the volume for a specific speaker.
    #
    # setting - Float 0.0 to 1.0 volume level.
    #
    # Returns Float new volume level.
    def volume=(setting)
      app.speakers.ID(@id).volume.set setting
      volume
    end

    # The hashed representation of a Speaker.
    #
    # Returns a Hash.
    def to_hash
      {
        :id => @id,
        :name => name,
        :connected => connected?,
        :volume => volume
      }
    end

    # Check if the speaker ID is valid.
    #
    # id - Airfoil speaker ID.
    #
    # Returns boolean
    def self.valid_id?(id)
      speaker_ids = Airfoil.get_speakers.map { |speaker| speaker.id }
      speaker_ids.include?(id)
    end

  end
end
