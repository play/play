require 'test_helper'

class UsersTest < ActiveSupport::TestCase

  context "Users" do
    setup do
      @authorized_user = User.make!(:login => 'tater')
    end

    test "GET /artists" do
      Artist.make(:name => 'Daft Punk')

      authorized_get '/api/artists', @authorized_user
      parsed_response = parse_response(last_response)

      assert_equal 406, last_response.status
      assert_json last_response
      assert_equal Hash, parsed_response.class
    end

    test "GET /artists/:artist_name" do
      Artist.make(:name => 'Daft Punk')

      authorized_get '/api/artists/daft%20punk', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_artist_representation parsed_response
    end

  end
end
