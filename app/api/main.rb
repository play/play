module Play
  class App < Sinatra::Base

    get "/now_playing" do
      Player.now_playing.to_json
    end
    
    get "/images/art/:id.png" do
      content_type 'image/png'

      if art = Song.find(params[:id]).album_art_data
        art
      else
        dir = File.dirname(File.expand_path(__FILE__))
        send_file "#{dir}/../frontend/public/images/album-placeholder.png",
          :disposition => 'inline'
      end
    end

  end
end
