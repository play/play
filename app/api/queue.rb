module Play
  class App < Sinatra::Base

    get "/queue" do
      Queue.to_json
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