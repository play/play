module Play

  # Realtime handles pushing updates to Pusher which in turn updates the
  # play web client.
  class Realtime
      
    # Public: Sends updated now playing song and queue.
    #
    # now_playing - Song we want the web client to say is now playing.
    #
    # Returns true/false based on success.
    def self.update_now_playing(now_playing)
      song = Yajl.dump now_playing.to_hash
      Pusher["now_playing_updates"].trigger("update_now_playing", song)
    rescue Pusher::Error => e
      false
    end

  end

end