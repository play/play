module Play
  # Lets us DJ.
  class App < Sinatra::Base
    post "/dj" do
      Player.pause
      `script/record start`
    end

    delete "/dj" do
      `script/record stop #{current_user.login}`
      Player.play
    end
  end
end