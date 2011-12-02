require 'helper'
require 'play/clients/testclient'
include Rack::Test::Methods

def app
  Play::App
end

context "Api" do
  fixtures do
    @artist = Play::Artist.create(:name => "Justice")
    @album  = Play::Album.create(:name  => "Cross", :artist => @artist)
    @song   = Play::Song.create(:title  => "Stress", 
                                :artist => @artist,
                                :album  => @album)
    @user = Play::User.create(:login => 'holman', :alias => 'zach')

    Play.class_eval do
      def self.client
        return Play::TestClient
      end
    end
  end

  test "/api/now_playing" do
    Play.expects(:now_playing).returns(@song)
    get "/api/now_playing"
    now_playing = parse_json(last_response.body.strip)
    assert_equal @artist.name, now_playing[:artist_name]
    assert_equal @song.title,  now_playing[:song_title]
    assert_equal @album.name,  now_playing[:album_name]
    assert_equal "/song/#{@song.id}/download", now_playing[:song_download_path]
    assert_equal "/album/#{@album.id}/download", now_playing[:album_download_path]
  end

  test "/api/say" do
    Play::TestClient.expects(:say).with("Holman is sexy").returns(true)
    get "/api/say", { :message => "Holman is sexy" }
    resp = parse_json(last_response.body.strip)
    assert_equal "Okay.", resp[:success]
  end

  test "/api requires user_login" do
    post "/api/add_song", {}
    user = parse_json(last_response.body.strip)
    assert user[:error].include?("must supply a valid `user_login`")
  end

  test "user login check also works for aliases" do
    post "/api/add_song", {:user_login => 'zach'}
    user = parse_json(last_response.body.strip)
    assert !user[:error].include?("must supply a valid `user_login`")
  end

  test "/api/star_now_playing" do
    Play.stubs(:now_playing).returns(@song)
    post "/api/star_now_playing", { :user_login => @user.login }
    song = parse_json(last_response.body.strip)
    assert_equal @song.title, song[:song_title]
  end

  test "/api/play_stars" do
    @song.star!(@user)
    post "/api/play_stars", { :user_login => @user.login }
    song = parse_json(last_response.body.strip)
    assert_equal @song.title, song[:song_title]
  end

  test "/api/add_song" do
    post "/api/add_song", { :song_title => @song.title,
                            :artist_name => @artist.name,
                            :user_login => @user.login }
    song = parse_json(last_response.body.strip)
    assert_equal @song.title, song[:song_title]
  end

  test "/api/add_song without a found artist" do
    post "/api/add_song", { :song_title => 'Stress',
                            :artist_name => "Ace of Base",
                            :user_login => @user.login }
    resp = parse_json(last_response.body.strip)
    assert resp[:error].include?("find that artist")
  end

  test "/api/add_song without a found song" do
    post "/api/add_song", { :song_title => "I Saw the Sign",
                            :artist_name => @artist.name,
                            :user_login => @user.login }
    resp = parse_json(last_response.body.strip)
    assert resp[:error].include?("find that song")
  end

  test "/api/add_artist" do
    post "/api/add_artist", { :artist_name => @artist.name,
                              :user_login => @user.login }
    song = parse_json(last_response.body.strip)
    assert_equal @artist.name, song[:artist_name]
    assert_equal [@song.title], song[:song_titles]
  end

  test "/api/add_album" do
    post "/api/add_album", { :name => @album.name,
                             :user_login => @user.login }
    response = parse_json(last_response.body.strip)
    assert_equal @artist.name, response[:artist_name]
    assert_equal @album.name, response[:album_name]
  end

  test "/api/remove" do
    post "/api/remove"
    resp = parse_json(last_response.body.strip)
    assert resp[:error].include?("hasn't been implemented")
  end

  test "/api/search artist" do 
    get "/api/search", { :q => @artist.name,
                         :facet => 'artist' }
    resp = parse_json(last_response.body.strip)
    assert resp[:song_titles].include?(@song.title)
  end

  test "/api/search song" do 
    get "/api/search", { :q => @song.title,
                         :facet => 'song' }
    resp = parse_json(last_response.body.strip)
    assert resp[:song_titles].include?(@song.title)
  end

  test "/api/user/add_alias" do
    post "/api/user/add_alias", { :login => @user.login, :alias => 'zach' }
    resp = parse_json(last_response.body.strip)
    assert 'true', resp[:success].to_s
    assert_equal 'zach', User.first.alias
  end

  test "/api/import" do
    Library.stubs(:import_songs).returns('true')
    post "/api/import"
    resp = parse_json(last_response.body.strip)
    assert_equal 'true', resp[:success]
  end

  test "/api/volume" do
    Play::TestClient.expects(:volume).with('3').returns(true)
    post "/api/volume", {:level => 3}
    resp = parse_json(last_response.body.strip)
    assert_equal 'true', resp[:success]
  end

  test "/api/volume with a float" do
    Play::TestClient.expects(:volume).with("2.5").returns(true)
    post "/api/volume", {:level => '2.5'}
    resp = parse_json(last_response.body.strip)
    assert_equal 'true', resp[:success]
  end

  test "/api/pause" do
    Play::TestClient.expects(:pause).returns(true)
    post "/api/pause"
    resp = parse_json(last_response.body.strip)
    assert_equal 'true', resp[:success]
  end

  test "/api/next" do
    Play::TestClient.expects(:next).times(1).returns(true)
    post "/api/next"
    resp = parse_json(last_response.body.strip)
    assert_equal 'true', resp[:success]
  end
end
