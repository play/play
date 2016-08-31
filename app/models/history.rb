require 'time'

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
    STAR_WEIGHT = 3  # How much a song's score increases when a user stars it.

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
      $redis.set   "#{KEY}:songs:#{song.id}:last_played_at", Time.now.utc.iso8601

      # Persist into the specific user's histories.
      $redis.rpush "#{KEY}:#{user.login}:song_ids",       song.id
      $redis.rpush "#{KEY}:#{user.login}:ids",            uniq
      $redis.rpush "#{KEY}:#{user.login}:ids:#{uniq}:id", song.id
      
      # Maintain a counter for the song in global stats.
      self.incr_song(song, 1, Time.now)
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

    # Public: The last time a song was played.
    #
    # song - The Song object to look up
    #
    # Returns a Time object, or nil if the song has never been played.
    def self.song_last_played_at(song)
      return nil unless (val = $redis.get("#{KEY}:songs:#{song.id}:last_played_at"))
      Time.iso8601(val)
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

    # The user changes their rating of the current song.
    def self.incr_song(song, incr, at)
      key = at.strftime("%Y%m%d")
      key = "#{KEY}:#{key}"

      # Maybe use MULTI here?
      score = ($redis.zscore(key, song.id) || 0).to_i
      $redis.zadd key, score+incr, song.id
    end

    # Record the fact the current song was starred by a user in overall stats tracking.
    def self.star_song(song, at=Time.now)
      self.incr_song(song, STAR_WEIGHT, at)
    end

    # Record the fact the current song was unstarred.
    def self.unstar_song(song, at=Time.now)
      self.incr_song(song, -1*STAR_WEIGHT, at)
    end

    # Return the top N starred songs for the time range (with per-day "granularity")
    def self.popular(from, to, n=15)
      from_day = from.strftime("%Y%m%d")
      to_day = to.strftime("%Y%m%d")

      key = "#{KEY}:#{from_day}"
      if from_day.eql?(to_day)
        # Consult a single sorted set.
        ret = $redis.zrevrange(key, 0, n-1, :with_scores => true)
      else
        # Aggregate multiple sorted set results with ZUNIONSTORE.
        keys = []
        while !from_day.eql?(to_day)
          keys << key
          from += 24*60*60
          from_day = from.strftime("%Y%m%d")
          key = "#{KEY}:#{from_day}"
        end
        keys << key

        tmp_key = "#{KEY}:#{Time.now.to_i}"
        $redis.zunionstore(tmp_key, keys)
        ret = $redis.zrevrange(tmp_key, 0, n-1, :with_scores => true)
        $redis.del(tmp_key)
      end

      # looks like [id1, score1, id2, score2]
      pairs = (ret.size/2-1)
      0.upto(pairs).map do |i|
        song_id = ret[i*2]
        score = ret[i*2+1]

        [ Song.find(song_id), score ]
      end
    end
  end
end
