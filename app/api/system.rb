module Play
  # API endpoints to support broader, systems-level functions.
  class App < Sinatra::Base

    get "/images/art/:id.png" do
      content_type 'image/png'

      if art = Song.find(params[:id]).album_art_data
        response['Cache-Control'] = 'public, max-age=2500000'
        etag params[:id]
        art
      else
        dir = File.dirname(File.expand_path(__FILE__))
        send_file "#{dir}/../frontend/public/images/album-placeholder.png",
          :disposition => 'inline'
      end
    end

    post '/upload' do
      puts params.inspect
      unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
        return haml(:upload)
      end
      while blk = tmpfile.read(65536)
          File.open(File.join(Dir.pwd,"public/uploads", name), "wb") { |f| f.write(tmpfile.read) }
      end
     'success'
    end

  end
end
