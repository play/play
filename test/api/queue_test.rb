require 'test_helper'

class QueueTest < ActiveSupport::TestCase

  context "Queue" do
    setup do
      @song = Song.make
      @authorized_user = User.make!(:login => 'tater')
    end

    test "GET /queue" do
      PlayQueue.add(@song,@user)
      Play.mpd.play

      authorized_get '/api/queue', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys

      assert_equal 1, keys.size
      assert keys.include? 'songs'
      assert_equal Array, parsed_response['songs'].class

      assert_song_representation parsed_response['songs'].first
    end

  end
end
