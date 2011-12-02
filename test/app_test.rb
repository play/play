require 'helper'
include Rack::Test::Methods

def app
  Play::App
end

context "App" do
  include Play

  fixtures do
    @artist = Artist.create(:name => 'Justice')
    @song = Song.create(:title => 'Stress', :artist => @artist)
  end

  setup do
    @user = Play::User.new(:login => 'holman',
                        :email => 'holman@example.com',
                        :office_string => 'holman')
    Play::App.any_instance.stubs(:current_user).returns(@user)
  end

  test "/login" do
    get '/login'
    assert last_response.redirect?
  end

  test "/auth/github/callback" do
    Play::User.expects(:authenticate).with('trololol').returns(@user)
    auth = { 'omniauth.auth' => {'user_info' => 'trololol'} }
    get "/auth/github/callback", nil, auth
    assert last_response.redirect?
  end

  test "/now_playing" do
    Play.expects(:now_playing).returns(@song)
    get "/now_playing"
    assert last_response.body.include?("Stress")
  end

  test "/play/album" do
    @album = Album.new
    Album.stubs(:find).returns(@album)
    @album.expects(:enqueue!)
    get "/play/album/1"
  end

#  test "/add existing song" do
#    @song = Play::Song.new(:title => 'Stress')
#    Play::Song.any_instance.expects(:enqueue!)
#    get "/add/#{@song.id}"
#  end
#
#  test "/remove existing song" do
#    @song = Play::Song.new(:title => 'Stress')
#    Play::Song.any_instance.expects(:dequeue!)
#    get "/remove/#{@song.id}"
#  end

end
