require 'fileutils'

module Play
  class App < Sinatra::Base
    db_name = (ENV['RACK_ENV'] == 'test' ? 'play_test' : 'play')
    set :database, Play.config['db'].merge('database' => db_name)

    get "/download/*" do
      song = Song.new(params[:splat].first)

      send_file(File.join(Play.music_path,song.path), :disposition => 'attachment')
    end

    get "/:login/likes" do
      @user = User.find_by_login(params[:login])
      not_found if !@user

      @songs = @user.liked_songs
      erb :profile
    end

    post "/queue" do
      song = Song.new(params[:path])
      Queue.add(song,current_user)
      'added!'
    end

    delete "/queue" do
      song = Song.new(params[:path])
      Queue.remove(song,current_user)
      'deleted!'
    end

    post "/like" do
      current_user.like(params[:path])
    end

    put "/like" do
      current_user.unlike(params[:path])
    end

    post '/upload' do
      params[:files].each do |file|
        tmpfile = file[:tempfile]
        name    = file[:filename].chomp.delete("\000")

        # taglib needs a file extension (lol)
        new_tmp = File.join(File.dirname(tmpfile), File.basename(name))
        File.rename(tmpfile.path, new_tmp)
        song    = Song.new(new_tmp)

        # Import into our collection
        path = File.join(Play.music_path, song.artist_name, song.album_name)
        FileUtils.mkdir_p(path)
        File.rename song.path, File.join(path, File.basename(song.path))
      end

      true
    end
  end
end