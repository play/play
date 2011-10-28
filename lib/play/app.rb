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

    configure :development,:production do
      # This should use Play.config eventually, but there's some weird loading
      # problems right now with this file. So it goes. Dupe it for now.
      config = YAML::load(File.open("#{ENV['HOME']}/.play.yml"))
      ActiveRecord::Base.establish_connection(config['db'])
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
          redirect '/login' unless request.path_info =~ /\/login/ ||
                                   request.path_info =~ /\/auth/  ||
                                   request.path_info =~ /\/api/
        end
      end
    end

    get "/" do
      @songs = Song.queue.all
      mustache :index
    end

    get "/devlogin" do
      session['user_id'] = User.create(:login => 'user',
                                       :email => 'play@example.com').id
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
      @song = Play.now_playing
      mustache :now_playing
    end

    get "/add/:id" do
      @song = Song.find(params[:id])
      @song.enqueue!(current_user)
      redirect '/'
    end

    get "/remove/:id" do
      @song = Song.find(params[:id])
      @song.dequeue!(current_user)
      redirect '/'
    end

    get "/artist/*/album/*" do
      @artist = Artist.where(:name => params[:splat].first).first
      @album = @artist.albums.where(:name => params[:splat].last).first
      @songs = @album.songs
      mustache :album_songs
    end

    get "/artist/*" do
      @artist = Artist.where(:name => params[:splat].first).first
      @songs = @artist.songs
      mustache :artist_songs
    end

    get "/song/:id" do
      @song = Song.find(params[:id])
      mustache :show_song
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

    get "/:login" do
      @user = User.where(:login => params[:login]).first
      mustache :profile
    end
  end
end
