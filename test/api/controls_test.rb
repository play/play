require 'test_helper'

class ControlsTest < ActiveSupport::TestCase

  context "Controls" do
    setup do
      @user = User.make!
    end

    context "/now_playing" do
      test "when nothing is playing" do
        authorized_get '/api/now_playing', @user
        parsed_response = parse_response(last_response)

        assert last_response.ok?
        assert_json last_response
        assert_equal Hash, parsed_response.class

        keys = parsed_response.keys

        assert_equal 1, keys.size
        assert keys.include? 'now_playing'

        assert_nil parsed_response['now_playing']
      end

      test "when something is playing" do
        authorized_get '/api/now_playing', @user
        parsed_response = parse_response(last_response)

        assert last_response.ok?
        assert_json last_response
        assert_equal Hash, parsed_response.class

        keys = parsed_response.keys

        assert_equal 1, keys.size
        assert keys.include? 'now_playing'

        assert_nil parsed_response['now_playing']
      end

    end

  end
end
