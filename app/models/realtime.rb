module Play

  # Realtime handles pushing updates to Pusher which in turn updates the
  # play web client.
  class Realtime

    # Public: Pushes an update event to Pusher.
    # 
    # channel - String channel the event is sent to.
    # event - String event that is triggered.
    # data - JSON string containing data associated with the event.
    #
    def self.push_update(channel, event, data)
      Pusher[channel].trigger(event, data)
    rescue Pusher::Error => e
    end
      
    # Public: Sends updated now playing song and queue.
    #
    # now_playing_and_queue - JSON string of now_playing Song and the
    # current Queue.
    #
    def self.update_queue_and_now_playing(now_playing, queue)
      now_playing = now_playing.to_hash if now_playing

      songs = queue
      songs.shift

      data = Yajl.dump({
        :now_playing => now_playing,
        :songs       => songs.map {|song| song.to_hash }
      })

      push_update("now_playing_updates", "update_now_playing", data)
    end

  end

end