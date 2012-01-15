module Play
  # Keeps track of the historical record of Play. Think plays and user votes and
  # playcounts, oh my.
  #
  # redis:
  #
  #   Histories are stored in two places, in two scopes: a dumb list for the
  #   sake of quickly pulling an ordered Array of integers, and a smart Sorted
  #   Set so we can get more information about that particular history item.
  #
  #   The Sorted Sets contain the following:
  #
  #     id, created_at (the "date played"), login (if relevant)
  #
  #   The keys are stored in redis as follows:
  #
  #     play:histories:ids            - A List of all song IDs played.
  #     play:histories:songs          - A Sorted Set of all songs played.
  #     play:histories:#{login}:ids   - A List of song IDs played by the user.
  #     play:histories:#{login}:songs - A Sorted Set of songs played by user.
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