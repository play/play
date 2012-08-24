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
    
    get "/song/:id" do
      song = Song.find(params[:id])
      song.starred = current_user.starred?(song)
      Yajl.dump song.to_hash
    end

    get "/song/:id/download" do
      song = Song.find(params[:id])
      send_file song.path, :disposition => 'attachment'
    end

    get "/artist/:artist/album/:album/download" do
      album = Album.new(params[:album],params[:artist])
      album.zipped!
      send_file album.zip_path, :disposition => 'attachment'
    end

    get "/history" do
      songs = History.last(30)
      songs_as_json(songs,current_user)
    end

    # GET /popular?days=7&limit=50
    #
    # Get the 50 most popular songs for the last 7 days. Returns a JSON hash of songs (with score).
    get "/popular" do
      lookback = (params[:days] || 1).to_i
      limit = (params[:limit] || 15).to_i
      scored_songs = History.starred(Time.now-lookback*24*60*60, Time.now, limit)
      scored_songs_as_json(scored_songs,current_user)
    end
  end
end
