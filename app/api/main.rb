module Play
  # API endpoints to support broader, systems-level functions.
  class App < Sinatra::Base

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
