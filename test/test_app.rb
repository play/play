require 'helper'
include Rack::Test::Methods

def app
  Play::App
end

context "App" do
  setup do
    @user = Play::User.new(:login => 'holman',
                        :email => 'holman@example.com',
                        :office_string => 'holman')
    Play::App.any_instance.stubs(:current_user).returns(@user)
  end

  test "/" do
    get '/'
    assert last_response.body.include?("@holman")
    assert last_response.body.include?("queue is empty")
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
    @song = Play::Song.new(:title => 'Stress')
    Play.expects(:now_playing).returns(@song)
    get "/now_playing"
    assert last_response.body.include?("Stress")
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
