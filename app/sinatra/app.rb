# require 'fileutils'

# module Play
#   class App < Sinatra::Base
#     # Include our Sinatra Helpers.
#     include Play::Helpers
#     include Play::AuthenticationHelper
#     include Play::EagerLoadHelper

#     register Sinatra::Auth::Github
#     register Sinatra::ActiveRecordExtension
#     register Sinatra::Partial

#     configure :development do
#       register Sinatra::Reloader
#       also_reload 'app/models/*'
#     end

#     set :sessions, true
#     set :session_secret, Play.config['auth_token']
#     set :logging, true
#     set :partial_template_engine, :erb
#     set :partial_underscores, true

#     dir = File.dirname(File.expand_path(__FILE__))
#     public_dir = File.dirname(File.expand_path("#{dir}/../public"))
#     set :public_folder, public_dir
#     set :static, true
#     set :github_options, {
#       :scopes    => "user",
#       :secret    => Play.config['github']['secret'],
#       :client_id => Play.config['github']['client_id'],
#     }

#     db_name = (ENV['RACK_ENV'] == 'test' ? 'play_test' : 'play')
#     set :database, Play.config['db'].merge('database' => db_name)

#     before do
#       session_not_required = request.path_info =~ /\/login/ ||
#                              request.path_info =~ /\/auth/ ||
#                              request.path_info =~ /\/images/

#       if ENV['RACK_ENV']=='test' || session_not_required || current_user
#         return true
#       else
#         authenticate
#       end

#       @current_user = current_user
#     end

#     # Set up mpd to natively consume songs
#     Play.client.native :repeat,  [true]
#     Play.client.native :consume, [true]

#     # Scan for new songs just in case
#     Play.client.native :update

#     not_found do
#       erb :four_oh_four
#     end

#     get "/search" do
#       @filter = (params[:filter] || :any).to_sym
#       @songs = Song.find([@filter,params[:q]])
#       erb :search
#     end

#     get "/artist/:name/album/:title" do
#       @artist = Artist.new(CGI.unescape(params[:name]))
#       @album  = Album.new(@artist.name, CGI.unescape(params[:title]))
#       @songs  = @album.songs
#       erb :album_details
#     end

#     get "/artist/:name/song/:title" do
#       @artist = Artist.new(CGI.unescape(params[:name]))
#       @song  = @artist.songs.find{|song| song.title == CGI.unescape(params[:title])}
#       erb :song_details
#     end

#     get "/download/album/*" do
#       song = Song.new(params[:splat].first)
#       path = File.expand_path('..', File.join(Play.music_path,song.path))
#       zipped = song.album.zipped(path)

#       send_file(zipped, :disposition => 'attachment')
#     end

#     get "/download/*" do
#       song = Song.new(params[:splat].first)

#       send_file(File.join(Play.music_path,song.path), :disposition => 'attachment')
#     end

#     get "/:login" do
#       @user = User.find_by_login(params[:login])
#       not_found if !@user

#       @songs = @user.plays
#       erb :profile
#     end

#     get "/:login/likes" do
#       @user = User.find_by_login(params[:login])
#       not_found if !@user

#       @songs = @user.liked_songs
#       erb :profile
#     end

#     post "/queue" do
#       song = Song.new(params[:path])
#       Queue.add(song,current_user)
#       'added!'
#     end

#     delete "/queue" do
#       song = Song.new(params[:path])
#       Queue.remove(song,current_user)
#       'deleted!'
#     end

#     post "/like" do
#       current_user.like(params[:path])
#     end

#     put "/like" do
#       current_user.unlike(params[:path])
#     end

#     post '/upload' do
#       params[:files].each do |file|
#         tmpfile = file[:tempfile]
#         name    = file[:filename].chomp.delete("\000")

#         # taglib needs a file extension (lol)
#         new_tmp = File.join(File.dirname(tmpfile), File.basename(name))
#         File.rename(tmpfile.path, new_tmp)
#         song    = Song.new(new_tmp)

#         # Import into our collection
#         path = File.join(Play.music_path, song.artist_name, song.album_name)
#         FileUtils.mkdir_p(path)
#         File.rename song.path, File.join(path, File.basename(song.path))
#       end

#       true
#     end
#   end
# end