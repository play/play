require 'test_helper'

class AlbumsTest < ActiveSupport::TestCase

  context "Albums" do
    setup do
      @authorized_user = User.make!(:login => 'tater')
      Album.make
    end

    test "GET /artists/:artist_name/albums" do
      authorized_get '/api/artists/Justice/albums', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys

      assert_equal 1, keys.size
      assert keys.include? 'albums'
      assert_equal Array, parsed_response['albums'].class

      assert_album_representation parsed_response['albums'].first
    end

    test "GET /artists/:artist_name/albums/:album_name" do
      authorized_get '/api/artists/Justice/albums/Cross', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_album_representation parsed_response
    end

    test "GET /artists/:artist_name/albums/:album_name/download" do
      authorized_get '/api/artists/Justice/albums/Cross/download', @authorized_user

      assert last_response.ok?
      assert_equal 'application/zip', last_response.headers["Content-Type"]
    end

  end
end
