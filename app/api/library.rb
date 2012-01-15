module Play
  # API endpoints to query and modify your library.
  class App < Sinatra::Base
    get "/search" do
      songs_as_json(Player.search(params[:q]),current_user)
    end

    get "/user/:login" do
      user = User.find(params[:login])
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

    get "/artist/:name" do
      artist = Artist.new(params[:name])
      songs_as_json(artist.songs,current_user)
    end

    get "/artist/:artist/album/:album" do
      album = Album.new(params[:album],params[:artist])
      songs_as_json(album.songs,current_user)
    end

    get "/song/:id/download" do
      song = Song.find(params[:id])
      send_file song.path, :disposition => 'attachment'
    end
  end
end