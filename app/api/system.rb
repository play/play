module Play
  # API endpoints to support broader, systems-level functions.
  class App < Sinatra::Base

    get "/images/art/:id.png" do
      content_type 'image/png'

      song = Song.find(params[:id])
      art = song.album_art_data if song

      if art
        response['Cache-Control'] = 'public, max-age=2500000'
        etag params[:id]
        art
      else
        dir = File.dirname(File.expand_path(__FILE__))
        send_file "#{dir}/../frontend/public/images/art-placeholder.png",
          :disposition => 'inline'
      end
    end

    get "/streaming_info" do
      streaming_data = {:stream_url => Play.config.stream_url, :pusher_key => Play.config.pusher_key}
      Yajl.dump(streaming_data)
    end

    get "/stream_url" do
      Yajl.dump({:stream_url => Play.config.stream_url})
    end
    
    post '/fetch' do
      if params[:url]
        system "./script/fetch", params[:url]
      end
      
      true
    end

    post '/upload' do
      params[:files].each do |file|
        tmpfile = file[:tempfile]
        name    = file[:filename].chomp.delete("\000")

        file_with_name = File.join("/tmp", name)
        system "mv", tmpfile.path, file_with_name
        system "./script/add-to-itunes", file_with_name
        system "rm", file_with_name
      end

      true
    end

  end
end
