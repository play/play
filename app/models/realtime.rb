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
    # now_playing - Song we want the web client to say is now playing.
    #
    def self.update_now_playing(now_playing)
      song = Yajl.dump now_playing.to_hash
      push_update("now_playing_updates", "update_now_playing", song)
    end

  end

end