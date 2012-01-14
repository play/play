module Play
  # API endpoints surrounding *control* over your Player. Think that top part of
  # the iTunes interface.
  class App < Sinatra::Base

    get "/now_playing" do
      Player.now_playing.to_json
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
      Player.say params[:message]
    end
    
  end
end
