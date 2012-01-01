require 'app/api/main'

module Play
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_directory, "#{dir}/../../public"
    set :static, true
    set :mustache, {
      :namespace => Play,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }

    def current_user
      #session['user_id'].blank? ? nil : User.find_by_id(session['user_id'])
    end

    configure :development do
      # This should use Play.config eventually, but there's some weird loading
      # problems right now with this file. So it goes. Dupe it for now.
      config = YAML::load(File.open("config/play.yml"))
    end

    configure :test do
    end

    before do
      return
      if current_user
        @login = current_user.login
      else
        if ENV['RACK_ENV'] != 'test'
          redirect '/login' unless request.path_info =~ /\/login/    ||
                                   request.path_info =~ /\/devlogin/ ||
                                   request.path_info =~ /\/auth/     ||
                                   request.path_info =~ /\/api/
        end
      end
    end

    # This is a stub for play-next until the proper API is created.
    get "/next.json" do
      {:song => {:title => 'Stress', :artist => 'Justice'}}.to_json
    end

    get "/" do
      #@current  = current_song
      #@songs    = [@current]
      #@songs   << Song.queue.includes(:album, :artist, :votes).all
      #@songs.flatten!
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
      send_file @song.path, :disposition => 'attachment'
    end

    get "/album/:id/download" do
      @album = Album.find(params[:id])
      @album.zipped!
      send_file @album.zip_path, :disposition => 'attachment'
    end

    get "/search" do
      @search = params[:q]
      artist = Artist.where("LOWER(name) = ?", @search.downcase).first
      redirect "/artist/#{URI.escape(artist.name)}" if artist
      @songs = Song.where("title LIKE ?", "%#{@search}%").limit(100).all
      mustache :search
    end

    get "/history" do
      @songs = History.limit(30).order('created_at desc').collect(&:song)
      mustache :play_history
    end

    get "/:login" do
      @user = User.where(:login => params[:login]).first
      mustache :profile
    end
  end
end
