module Play
  class App < Sinatra::Base
    # Include our Sinatra Helpers.
    include Play::Helpers
    include Play::AuthenticationHelper

    register Mustache::Sinatra
    register Sinatra::Auth::Github
    register Sinatra::ActiveRecordExtension

    set :sessions, true
    set :session_secret, Play.config['auth_token']

    dir = File.dirname(File.expand_path(__FILE__))
    public_dir = File.dirname(File.expand_path("#{dir}/../public"))
    set :public_folder, public_dir
    set :static, true
    set :mustache, {
      :namespace => Play,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }
    set :github_options, {
      :scopes    => "user",
      :secret    => Play.config['github']['secret'],
      :client_id => Play.config['github']['client_id'],
    }

    db_name = (ENV['RACK_ENV'] == 'test' ? 'play_test' : 'play')
    set :database, Play.config['db'].merge('database' => db_name)

    before do
      session_not_required = request.path_info =~ /\/login/ ||
                             request.path_info =~ /\/auth/ ||
                             request.path_info =~ /\/images/

      if ENV['RACK_ENV']=='test' || session_not_required || current_user
        true
      else
        authenticate
      end

      @current_user = current_user
    end

    not_found do
      mustache :four_oh_four
    end

    get "/" do
      @songs = Queue.songs
      mustache :index
    end

    get "/search" do
      @songs = Song.find([:any,params[:q]])
      mustache :search
    end

    get "/artist/:name" do
      @artist = Artist.new(params[:name])
      @songs  = @artist.songs
      mustache :artist_profile
    end

    get "/artist/:name/album/:title" do
      @artist = Artist.new(params[:name])
      @album  = Album.new(@artist.name, params[:title])
      @songs  = @album.songs
      mustache :album_details
    end

    get "/artist/:name/song/:title" do
      @artist = Artist.new(params[:name])
      @song  = @artist.songs.find{|song| song.title == params[:title]}
      mustache :song_details
    end

    get "/download/album/*" do
      song = Song.new(params[:splat].first)
      path = File.expand_path('..', File.join(Play.music_path,song.path))
      zipped = song.album.zipped(path)

      send_file(zipped, :disposition => 'attachment')
    end

    get "/download/*" do
      song = Song.new(params[:splat].first)

      send_file(File.join(Play.music_path,song.path), :disposition => 'attachment')
    end

    get "/:login" do
      @user = User.find_by_login(params[:login])
      not_found if !@user

      @songs = @user.plays
      mustache :profile
    end

    get "/:login/likes" do
      @user = User.find_by_login(params[:login])
      not_found if !@user

      @songs = @user.liked_songs
      mustache :profile
    end

    get "/images/art/:album_art_file" do
      cached_album_art_path = "#{Play.album_art_cache_path}/#{params[:album_art_file]}"

      if File.exists? cached_album_art_path
        art_path = cached_album_art_path
      else
        art_path = 'app/assets/images/art-placeholder.png'
      end

      send_file(art_path, :disposition => 'inline')
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

    delete "/like" do
      current_user.dislike(params[:path])
    end
  end
end