require 'test_helper'

class SongsTest < ActiveSupport::TestCase

  context "Songs" do
    setup do
      Song.make
      @authorized_user = User.make!(:login => 'tater')
    end

    test "GET /artists/:artist_name/songs/:song_name" do
      authorized_get '/api/artists/Justice/songs/Stress', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_song_representation parsed_response
    end

    test "GET /artists/:artist_name/songs/:song_name/download" do
      authorized_get '/api/artists/Justice/songs/Stress/download', @authorized_user

      assert last_response.ok?
      assert_equal 'application/octet-stream', last_response.headers["Content-Type"]
    end

    test "PUT /artists/:artist_name/songs/:song_name/like" do
      authorized_put '/api/artists/Justice/songs/Stress/like', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_song_representation parsed_response
    end

    test "PUT /artists/:artist_name/songs/:song_name/unlike" do
      authorized_put '/api/artists/Justice/songs/Stress/unlike', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_song_representation parsed_response
    end


  end
end
