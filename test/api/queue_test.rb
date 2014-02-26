require 'test_helper'

class QueueTest < ActiveSupport::TestCase

  context "Queue" do
    setup do
      @song = Song.make
      @authorized_user = User.make!(:login => 'tater')

      PlayQueue.add(@song,@user)
      Play.mpd.play

      stub_request(:get, /resolve/).to_return(status: 200, body: soundcloud_response, headers: {})
    end

    test "GET /queue" do

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

    test "POST /queue/add" do
      authorized_post '/api/queue/add', @authorized_user, {:artist_name => @song.artist.to_param, :song_name => @song.to_param, :type => 'song'}
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

    test "POST /queue/add (soundcloud)" do
      authorized_post '/api/queue/add', @authorized_user, {:url => 'https://soundcloud.com/snoopdogg/super-mario-bros-w-baseline', :type => 'soundcloud'}
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

    test "POST /queue/remove" do
      PlayQueue.add(Song.new(:path => %{Jeff Buckley/Grace/Lover, You Should've Come Over.mp3}),@user)

      authorized_post '/api/queue/remove', @authorized_user, {:artist_name => @song.artist.to_param, :song_name => @song.to_param}
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

    test "POST /queue/clear" do
      authorized_post '/api/queue/clear', @authorized_user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys

      assert_equal 1, keys.size
      assert keys.include? 'songs'
      assert_equal Array, parsed_response['songs'].class
    end


  end
end
