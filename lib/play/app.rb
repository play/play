require 'play/app/api'

module Play
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder,    "#{dir}/../../public"
    set :static,    true
    set :mustache, {
      :namespace => Play,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }

    def current_user
      session['user_id'].blank? ? nil : User.find_by_id(session['user_id'])
    end

    def current_song
      Play.now_playing
    end

    configure :development do
      # This should use Play.config eventually, but there's some weird loading
      # problems right now with this file. So it goes. Dupe it for now.
      config = YAML::load(File.open("config/play.yml"))
      ActiveRecord::Base.establish_connection(config['db'])
      # ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    configure :test do
      ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',
                                              :database => ":memory:")
    end

    before do
      if current_user
        @login = current_user.login
      else
        if ENV['RACK_ENV'] != 'test'
          redirect '/login' unless request.path_info =~ /\/login/    ||
                                   request.path_info =~ /\/devlogin/ ||
                                   request.path_info =~ /\/auth/     ||
                                   request.path_info =~ /\/api/      ||
                                   request.path_info =~ /\/rdio/
        end
      end
    end

    get "/" do
      @recent   = History.limit(3).order('created_at').collect(&:song)
      @current  = current_song
      @songs    = [@current]
      @songs   << Song.queue.includes(:album, :artist, :votes).all
      @songs.flatten!
      mustache :index
    end

    get "/devlogin/:email" do
      session['user_id'] = User.create(:login => 'user',
                                       :email => params[:email]).id
      redirect '/'
    end

    get "/login" do
      redirect '/auth/github'
    end

    get '/auth/:name/callback' do
      auth = request.env['omniauth.auth']
      @user = User.authenticate(auth['user_info'])
      session['user_id'] = @user.id
      redirect '/'
    end

    get "/now_playing" do
      @song = current_song
      mustache :now_playing
    end

    post "/star/:id" do
      @song = Song.find(params[:id])
      @song.star!(current_user)
      "Starred"
    end

    post "/add/:id" do
      @song = Song.find(params[:id])
      @song.enqueue!(current_user)
      "Queued"
    end

    get "/play/album/:id" do
      album = Play::Album.find(params[:id])
      album.enqueue!(current_user)
      redirect '/'
    end

    post "/remove/:id" do
      @song = Song.find(params[:id])
      @song.dequeue!(current_user)
      "Removed"
    end

    get "/album/:id" do
      @album  = Album.find(params[:id])
      @artist = @album.artist
      @songs  = @album.songs
      mustache :album_songs
    end

    get "/artist/*/album/*" do
      @artist = Artist.where(:name => params[:splat].first).first
      @album = @artist.albums.where(:name => params[:splat].last).first
      @songs = @album.songs
      mustache :album_songs
    end

    get "/artist/*" do
      @artist = Artist.
                  where(:name => params[:splat].first).
                  includes(:songs => [:album, :artist]).
                  first
      return mustache :four_oh_four if !@artist
      @songs = @artist.songs
      mustache :artist_songs
    end

    get "/song/:id" do
      @song = Song.find(params[:id])
      mustache :show_song
    end

    get "/song/:id/download" do
      @song = Song.find(params[:id])
      send_file @song.path
    end

    get "/album/:id/download" do
      @album = Album.find(params[:id])
      @album.zipped!
      send_file @album.zip_path.gsub('\ ',' ')
    end

    get "/search" do
      @search = params[:q]
      artist = Artist.where("LOWER(name) = ?", @search.downcase).first
      redirect "/artist/#{URI.escape(artist.name)}" if artist
      @songs = Song.where("title LIKE ?", "%#{@search}%").limit(100).all
      mustache :search
    end

    get "/history" do
      @songs = History.limit(100).order('created_at desc').collect(&:song)
      mustache :play_history
    end
    
    get "/rdio/:track_id/done" do
      Play::Library.instance("Play::Rdio::Library").quit_browser(params[:track_id])
      "thanks!"
    end
    
    get "/rdio/:track_id" do
      @track_id = params[:track_id]
      play = YAML::load(File.open("config/play.yml"))
      @domain = play["domain"] || "localhost"
      @playback_token = play["rdio"]["playback_token"] if play["rdio"] && play["rdio"]["playback_token"]
      @playback_token ||= "GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc="
      mustache :rdio
    end

    get "/:login" do
      @user = User.where(:login => params[:login]).first
      mustache :profile
    end
    

  end
end
