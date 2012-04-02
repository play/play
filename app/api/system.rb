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
        send_file "#{dir}/../frontend/public/images/art-placeholder.png",
          :disposition => 'inline'
      end
    end

    get "/stream_url" do
      Play.config.stream_url
    end

    post '/upload' do
      params[:files].each do |file|
        tmpfile = file[:tempfile]
        name    = file[:filename]

        file_with_name = File.join("/tmp", name)
        system "mv", tmpfile.path, file_with_name
        system "./script/add-to-itunes", file_with_name
        system "rm", file_with_name
      end

      true
    end

  end
end
