module Play
  # API endpoints to support broader, systems-level functions.
  class App < Sinatra::Base

    get "/images/art/:id.png" do
      content_type 'image/png'

      song = Song.find(params[:id])
      if song and art = song.album_art_data
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

    post '/upload' do
      params[:files].each do |file|
        tmpfile = file[:tempfile]
        name    = file[:filename]

        # iTunes needs a filetype it likes, so fuck it, .mp3 it.
        system "mv", tmpfile.path, tmpfile.path + '.mp3'
        system "./script/add-to-itunes", tmpfile.path + '.mp3'
      end

      true
    end

  end
end
