module Play
  class App < Sinatra::Base

    get "/search" do
      hash ={
        :songs => Player.search(params[:q]).map { |song| song.to_json }
      }
      Yajl.dump hash
    end
    
  end
end