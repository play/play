module Play
  # API endpoints surrounding *control* over your Player. Think that top part of
  # the iTunes interface.
  class App < Sinatra::Base

    get "/now_playing" do
      if Player.now_playing
        Yajl.dump Player.now_playing.to_hash
      else
        nil
      end
    end

    put "/play" do
      Player.play
    end

    put "/pause" do
      Player.pause
    end

    put "/next" do
      Player.play_next
    end

    put "/previous" do
      Player.play_previous
    end

    post "/say" do
      if params[:message] && params[:message].size > 0
        Player.say params[:message]
      end
    end

  end
end
