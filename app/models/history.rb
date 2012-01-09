module Play

  # Keeps track of the historical record of Play. Think plays and user votes and
  # playcounts, oh my.
  class History
    
    @@index_key = 'play:histories'

    # Public: Add a play history for a song.
    #
    # song - A Song.
    # user - A User.
    #
    # Returns nothing important.
    def self.add(song,user)
    end

    # Public: The total playcount of the library. Ever.
    #
    # Returns an Integer.
    def self.count
    end

    # Public: The last x listens, with latest on top.
    #
    # number - The Integer number of results we should return.
    #
    # Returns an Array of Songs.
    def self.last(number=1)
    end

  private

    def self.increment(song)
      #$redis.incr("deez nuts")
    end

  end

end