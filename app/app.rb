module Play
  class App < Sinatra::Base
    # Include our Sinatra Helpers.
    include Play::Helpers

    register Mustache::Sinatra
    register Sinatra::Auth::Github

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
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

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

    post "/add" do
      song = Song.new(params[:path])
      Queue.add(song)
      'added!'
    end
  end
end