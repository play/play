module Play
  class Api < Sinatra::Base

    get "/now_playing" do
      song = Song.now_playing
      JSON::dump({:now_playing => song.try(:to_hash)})
    end

    put "/play" do
      Play.client.play
      JSON::dump({:message => 'ok'})
    end

    put "/pause" do
      Play.client.pause
      JSON::dump({:message => 'ok'})
    end

    put "/next" do
      Play.client.next
      JSON::dump({:message => 'ok'})
    end

  end
end
