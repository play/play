module Play
  # API endpoints to query and modify your library.
  class App < Sinatra::Base

    get "/search" do
      songs_as_json(Player.search(params[:q]),current_user)
    end

    get "/user/:splat" do
      user = User.find(params[:splat].first)
      songs_as_json(user.stars,current_user)
    end

    post "/star" do
      song = Song.find(params[:id])
      current_user.star(song)
    end

    delete "/star" do
      song = Song.find(params[:id])
      current_user.unstar(song)
    end

  end
end