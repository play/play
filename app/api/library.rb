module Play
  class Api < Sinatra::Base
    get "/search" do
    end

    get "/artists/:name" do
    end

    get "/artists/:name/albums" do
    end

    get "/artists/:artist_name/albums/:name" do
    end

    get "/artists/:artist_name/albums/:name/download" do
    end

    get "/songs/:id/download" do
    end

    get "/artists/:name/songs" do
    end

    post "/likes" do
    end

    delete "/likes" do
    end

  end
end
