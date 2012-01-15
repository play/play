module Play
  # API endpoints dealing with managing your Queue.
  class App < Sinatra::Base

    get "/queue" do
      songs_as_json(Queue.songs,current_user)
    end

    post "/queue/add" do
      if params[:id]
        song = Song.find(params[:id])
      else
        song = Song.new(:name => params[:name], :artist => params[:artist])
      end
      Queue.add_song(song)
    end
    
  end
end