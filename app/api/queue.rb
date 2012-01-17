module Play
  # API endpoints dealing with managing your Queue.
  class App < Sinatra::Base

    get "/queue" do
      songs_as_json(Queue.songs,current_user)
    end

    post "/queue" do
      if params[:id]
        song = Song.find(params[:id])
      else
        song = Song.new(:name => params[:name], :artist => params[:artist])
      end
      Queue.add_song(song)
      History.add(song,current_user)
      true
    end

    delete "/queue" do
      if params[:id]
        song = Song.find(params[:id])
      else
        song = Song.new(:name => params[:name], :artist => params[:artist])
      end
      Queue.remove_song(song)
      true
    end

    post "/queue/stars" do
      songs = current_user.stars.shuffle[0..4]
      songs.each do |song|
        Queue.add_song(song)
        History.add(song,current_user)
      end

      songs_as_json(songs,current_user)
    end

  end
end