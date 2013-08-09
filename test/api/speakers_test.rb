require 'test_helper'

class SpeakersTest < ActiveSupport::TestCase

  context "Speakers" do
    setup do
      Play.speakers << Play::Speaker.new('floor-2-speaker', 'floor-2-speaker.local.', 9292)
      @authorized_user = User.make!(:login => 'tater')
    end

    test "GET /speakers" do
      authorized_get '/api/speakers', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys

      assert_equal 1, keys.size
      assert keys.include? 'speakers'
      assert_equal Array, parsed_response['speakers'].class

      assert_speaker_representation parsed_response['speakers'].first
    end

    test "404 on a GET /speakers/:speaker_name/mute" do
      authorized_post '/api/speakers/bad-speaker/mute', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.not_found?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys
    end

    test "POST /speakers/:speaker_name/mute" do
      authorized_post '/api/speakers/floor-2-speaker/mute', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_speaker_representation parsed_response
    end

    test "POST /speakers/:speaker_name/unmute" do
      authorized_post '/api/speakers/floor-2-speaker/unmute', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_speaker_representation parsed_response
    end

    test "POST /speakers/:speaker_name/volume" do
      authorized_post '/api/speakers/floor-2-speaker/volume', @authorized_user, {:level => 90}
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_speaker_representation parsed_response
    end



  end
end
