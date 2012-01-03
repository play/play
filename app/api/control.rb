module Play
  class App < Sinatra::Base

    put "/play" do
      Player.play
    end

    put "/pause" do
      Player.pause
    end
    
  end
end
