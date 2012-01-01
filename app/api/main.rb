module Play
  class App < Sinatra::Base

    get "/now_playing" do
      Player.now_playing.to_json
    end
    
  end
end
