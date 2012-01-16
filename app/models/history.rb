module Play
  # Keeps track of the historical record of Play. Think plays and user votes and
  # playcounts, oh my.
  #
  # redis:
  #
  #   Histories are stored in a couple of different spots. Typically we just
  #   access everything through the song_ids List, which gives us a quick last x
  #   played. All comprehensive histories can be pulled from some more detailed
  #   keys.
  #
  #   There's a concept of a unique ID involved here, which is a simple
  #   concatination of song ID and datetime the play was requested. This allows
  #   a general way of uniquely identifying a given play. That's then used as a
  #   key for other redis keys.
  #
  #   The keys are stored in redis as follows:
  #
  #     play:histories:song_ids          - A List of all song IDs played.
  #     play:histories:ids               - A List of all mappable IDs.
  #     play:histories:ids:#{uniq}:id    - The ID of the song played.
  #     play:histories:ids:#{uniq}:user  - The login of the user who played it.
  #
  #     play:histories:songs:#{id}:count - The playcount of the song.
  #
  #     play:histories:#{login}:song_ids - List of song IDs played by the user.
  #     play:histories:#{login}:ids      - A List of all user-mappable IDs.
  #     play:histories:#{login}:ids:#{uniq}:id - Song ID
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
      # Cache this moment in time.
      time = now

      # Generated unique identifier.
      uniq = song.id + time.to_s

      # Persist into the general population of plays.
      $redis.rpush "#{KEY}:song_ids",         song.id
      $redis.rpush "#{KEY}:ids",              uniq
      $redis.set   "#{KEY}:ids:#{uniq}:id",   song.id
      $redis.set   "#{KEY}:ids:#{uniq}:user", user.login

      # Increment the song's own playcount counter.
      $redis.incr  "#{KEY}:songs:#{song.id}:count"

      # Persist into the specific user's histories.
      $redis.rpush "#{KEY}:#{user.login}:song_ids",       song.id
      $redis.rpush "#{KEY}:#{user.login}:ids",            uniq
      $redis.rpush "#{KEY}:#{user.login}:ids:#{uniq}:id", song.id
    end

    # Public: The total playcount of the library. Ever.
    #
    # Returns an Integer.
    def self.count
      $redis.llen "#{KEY}:ids"
    end

    # Public: The total playcount of this song.
    #
    # Returns an Integer. Return zero in case of nil.
    def self.count_by_song(song)
      $redis.get("#{KEY}:songs:#{song.id}:count").to_i || 0
    end

    # Public: The last x listens, with latest on top.
    #
    # number - The Integer number of results we should return.
    #
    # Returns an Array of Songs.
    def self.last(number=1)
      ids = $redis.lrange "#{KEY}:song_ids", -number, -1
      ids.map do |id|
        Song.find(id)
      end
    end

    # The current datetime in UTC in convenient integer format.
    #
    # Returns an Integer.
    def self.now
      Time.now.to_i
    end
  end
end