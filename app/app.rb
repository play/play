module Play
  class App < Sinatra::Base
    # Include our Sinatra Helpers.
    include Play::Helpers

    register Mustache::Sinatra
    register Sinatra::Auth::Github
    register Sinatra::ActiveRecordExtension

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
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

    get "/images/art/*" do
      song = Song.new(params[:splat].first)

      content_type 'image/png'
      song.art
    end

    post "/queue" do
      song = Song.new(params[:path])
      Queue.add(song)
      'added!'
    end

    delete "/queue" do
      song = Song.new(params[:path])
      Queue.remove(song)
      'deleted!'
    end
  end
end