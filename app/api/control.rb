module Play
  # API endpoints surrounding *control* over your Player. Think that top part of
  # the iTunes interface.
  class App < Sinatra::Base

    get "/now_playing" do
      if Player.now_playing
        song = Player.now_playing
        song.starred = current_user.starred?(song)
        Yajl.dump song.to_hash
      else
        nil
      end
    end

    post "/now_playing" do
      song = Player.now_playing
      current_user.star(song)
      Yajl.dump song.to_hash
    end

    put "/play" do
      Player.play
    end

    put "/pause" do
      Player.pause
    end

    put "/next" do
      Yajl.dump Player.play_next.to_hash
    end

    put "/previous" do
      Player.play_previous
    end

    post "/say" do
      if params[:message] && params[:message].size > 0
        Player.say params[:message]
      end
      true
    end

    get "/app-volume" do
      Player.app_volume.to_s
    end

    put "/app-volume" do
      Player.app_volume = params[:volume]
      Player.app_volume.to_s
    end

    get "/system-volume" do
      Player.system_volume.to_s
    end

    put "/system-volume" do
      Player.system_volume = params[:volume]
      Player.system_volume.to_s
    end

  end
end
