module Play
  # API endpoints surrounding *control* over your @@player. Think that top part of
  # the iTunes interface.
  class App < Sinatra::Base
    case Play.config.player.downcase
    when "itunes"
      @@player = Player::Itunes
    else
      @@player = Player::Vlc
    end 

    get "/now_playing" do
      if @@player.now_playing
        song = @@player.now_playing
        song.starred = current_user.starred?(song)
        Yajl.dump song.to_hash
      else
        nil
      end
    end

    post "/now_playing" do
      song = @@player.now_playing
      current_user.star(song)
      Yajl.dump song.to_hash
    end

    put "/play" do
      @@player.play
    end

    put "/pause" do
      @@player.pause
    end

    put "/next" do
      Yajl.dump @@player.play_next.to_hash
    end

    put "/previous" do
      @@player.play_previous
    end

    post "/say" do
      if params[:message] && params[:message].size > 0
        @@player.say params[:message]
      end
      true
    end

    get "/app-volume" do
      @@player.app_volume.to_s
    end

    put "/app-volume" do
      @@player.app_volume = params[:volume]
      @@player.app_volume.to_s
    end

    get "/system-volume" do
      @@player.system_volume.to_s
    end

    put "/system-volume" do
      @@player.system_volume = params[:volume]
      @@player.system_volume.to_s
    end

  end
end
