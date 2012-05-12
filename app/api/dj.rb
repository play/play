module Play
  # Lets us DJ.
  class App < Sinatra::Base
    post "/dj" do
      Player.pause
      `script/record start`
    end

    delete "/dj" do
      `script/record stop #{params[:note]}`
      Player.play
      params[:note]
    end
  end
end