module Play
  class App < Sinatra::Base
    get "/api/now_playing" do
      song = Play.now_playing
      music_response(song)
    end

    get "/api/say" do
      Play.client.say(params[:message])
      { :success => "Okay." }.to_json
    end

    post "/api/user/add_alias" do
      user = User.find_by_login(params[:login])
      if user
        user.alias = params[:alias]
        { :success => user.save }.to_json
      else
        error_response "Couldn't find that user. Crap."
      end
    end

    post "/api/import" do
      if Library.import_songs
        { :success => 'true' }.to_json
      else
        error_response "Had some problems importing into Play. Uh-oh."
      end
    end

    post "/api/star_now_playing" do
      api_authenticate
      song = Play.now_playing
      song.star!(api_user)
      music_response(song)
    end

    post "/api/play_stars" do
      api_authenticate
      star = api_user.stars.sort_by{ rand }.first
      if song = star.song
        song.enqueue!(api_user)
        music_response(song)
      else
        error_response "You don't have any starred songs, you lazy bastard."
      end
    end

    post "/api/add_song" do
      api_authenticate
      artist = Artist.find_by_name(params[:artist_name])
      if artist
        song = artist.songs.find_by_title(params[:song_title])
        if song
          song.enqueue!(api_user)
          music_response(song)
        else
          error_response("Sorry, but we couldn't find that song.")
        end
      else
        error_response("Sorry, but we couldn't find that artist.")
      end
    end

    post "/api/add_artist" do
      api_authenticate
      artist = Artist.find_by_name(params[:artist_name])
      if artist
        {:song_titles => artist.enqueue!(api_user).collect(&:title),
         :artist_name => artist.name}.to_json
      else
        error_response("Sorry, but we couldn't find that artist.")
      end
    end

    post "/api/add_album" do
      api_authenticate
      album = Album.find_by_name(params[:name])
      if album
        album.enqueue!(api_user)
        {:artist_name => album.artist.name,
         :album_name => album.name}.to_json
      else
        error_response("Sorry, but we couldn't find that album.")
      end
    end

    post "/api/remove" do
      error_response "This hasn't been implemented yet. Whoops."
    end

    get "/api/search" do
      songs = case params[:facet]
      when 'artist'
        artist = Artist.find_by_name(params[:q])
        artist ? artist.songs : nil
      when 'song'
        Song.where(:title => params[:q])
      end

      songs ? {:song_titles => songs.collect(&:title)}.to_json : error_response("Search. Problem?")
    end
    
    get "/api/volume" do
      Play.client.volume().to_json
    end
    
    post "/api/volume" do
      if Play.client.volume(params[:level])
        { :success => 'true' }.to_json
      else
        error_response "There's a problem adjusting the volume."
      end
    end

    post "/api/pause" do
      if Play.client.pause
        { :success => 'true' }.to_json
      else
        error_response "There's a problem pausing."
      end
    end

    post "/api/next" do
      if Play.client.next
        { :success => 'true' }.to_json
      else
        error_response "There's a problem playing the next song."
      end
    end

    get "/api/stats" do
      playcounts = History.count
      obj = Song.limit(1).group("artist_id").select("artist_id, count(artist_id) as count").first
      artist = Artist.find(obj.artist_id)
      {
        :message => "Total plays: #{playcounts}"+
                    "\nFavorite artist: #{artist.name} (#{obj.count} plays)"
      }.to_json
    end

    def api_user
      User.find_by_login(params[:user_login]) ||
      User.find_by_alias(params[:user_login])
    end

    def api_authenticate
      if api_user
        true
      else
        halt error_response("You must supply a valid `user_login` in your requests.")
      end
    end

    def error_response(msg)
      { :error => msg }.to_json
    end

    def music_response(song)
      {
        'artist_name' => song.artist_name,
        'song_title'  => song.title,
        'album_name'  => song.album_name,
        'song_download_path' => "/song/#{song.id}/download",
        'album_download_path' => "/album/#{song.album_id}/download"
      }.to_json
    end
  end
end
