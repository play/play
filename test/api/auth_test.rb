require 'test_helper'

class AuthTest < ActiveSupport::TestCase

  context "Auth" do
    setup do
      @user = User.make!
    end

    context "global" do
      test "authorized request works" do
        get '/api/users', {"HTTP_AUTHENTICATION" => '123456789', "HTTP_X_PLAY_LOGIN" => @user.login}
        assert last_response.ok?
      end

      test "unauthorized request works" do
        get '/api/users', {"HTTP_AUTHENTICATION" => '222', "HTTP_X_PLAY_LOGIN" => @user.login}
        assert_equal 401, last_response.status
      end

    end

    context "by a user" do
      test "authorized request works" do
        authorized_get '/api/users', @user
        assert last_response.ok?
      end

      test "unauthorized request does not work" do
        unauthorized_get '/api/users'
        assert_equal 401, last_response.status
      end
    end

  end

end
