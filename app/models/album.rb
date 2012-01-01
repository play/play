module Play
  class Album

    # Persistent ID of the album.
    attr_accessor :id

    # Initializes a new Album instance.
    #
    # id - The persistent ID of the album.
    #
    # Returns the new Album.
    def initialize(id)
      @id = id
    end

  end
end