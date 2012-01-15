module Play
  # Keeps track of the historical record of Play. Think plays and user votes and
  # playcounts, oh my.
  #
  # redis:
  #
  #   play:histories:ids            - A List of all song IDs played.
  #   play:histories:songs          - A Sorted Set of all songs played. Values:
  #                                     - ID
  #                                     - Date
  #   play:histories:#{login}:ids   - A List of all song IDs played by the user.
  #   play:histories:#{login}:songs - A Sorted Set of all songs played by user.
  class History
    # The redis key to stash History data.
    KEY = 'play:histories'

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