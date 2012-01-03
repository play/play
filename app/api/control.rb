module Play
  class App < Sinatra::Base

    put "/play" do
      Player.play
    end

    put "/pause" do
      Player.pause
    end

    post "/say" do
      Player.say params[:message]
    end
    
  end
end
