module Play
  class App < Sinatra::Base

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
