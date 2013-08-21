require 'test_helper'

class UsersTest < ActiveSupport::TestCase

  context "Users" do
    setup do
      @authorized_user = User.make!(:login => 'tater')
    end

    test "GET /users" do
      User.make!(:login => 'maddox')
      User.make!(:login => 'holman')
      User.make!(:login => 'kneath')
      User.make!(:login => 'defunkt')

      authorized_get '/api/users', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys

      assert_equal 1, keys.size
      assert keys.include? 'users'
      assert_equal Array, parsed_response['users'].class

      assert_user_representation parsed_response['users'].first
    end

    test "GET /users/:login" do
      User.make!(:login => 'maddox')

      authorized_get '/api/users/maddox', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_user_representation parsed_response
    end

    test "GET /users/:login/likes" do
      user = User.make!(:login => 'maddox')
      user.like('Justice/Cross/Stress.mp3')

      authorized_get '/api/users/maddox/likes', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys
      assert_equal 2, keys.size
      assert keys.include? 'songs'
      assert keys.include? 'total_entries'
      assert_equal Array, parsed_response['songs'].class

      assert_song_representation parsed_response['songs'].first
    end


  end
end
