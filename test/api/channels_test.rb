require 'test_helper'

class ChannelsTest < ActiveSupport::TestCase
  context "Managing" do
    setup do
      @channel = Channel.make!
      @user = User.make!
    end

    test "GET Channels" do
      authorized_get "/api/channels", @user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      keys = parsed_response.keys

      assert_equal 1, keys.size
      assert keys.include? 'channels'

      assert_channel_representation parsed_response['channels'].first
    end

    test "GET Channel" do
      authorized_get "/api/channels/#{@channel.id}", @user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_channel_representation parsed_response
    end

    test "POST Channels" do
      authorized_post "/api/channels", @user, {:channel => {:name => 'test channel'}}
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_channel_representation parsed_response
    end

    test "PUT Channel" do
      authorized_put "/api/channels/#{@channel.id}", @user, {:channel => {:name => 'new name'}}
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_channel_representation parsed_response
    end

    test "DELETE Channel" do
      authorized_delete "/api/channels/#{@channel.id}", @user
      parsed_response = parse_response(last_response)

      assert last_response.ok?
      assert_json last_response
      assert_equal Hash, parsed_response.class

      assert_channel_representation parsed_response
    end

  end

  test "stream path" do
    channel = Channel.make!
    user = User.make!

    authorized_get "/api/channels/#{channel.id}/stream", user
    assert_equal 302, last_response.status
  end

  context "Controls" do
    setup do
      @channel = Channel.make!
      @user = User.make!
    end

    context "/now_playing" do
      test "when nothing is playing" do
        authorized_get "/api/channels/#{@channel.id}/now_playing", @user
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
        @song = Song.make
        @channel.add(@song,@user)
        @channel.mpd.play

        authorized_get "/api/channels/#{@channel.id}/now_playing", @user
        parsed_response = parse_response(last_response)

        assert last_response.ok?
        assert_json last_response
        assert_equal Hash, parsed_response.class

        keys = parsed_response.keys

        assert_equal 1, keys.size
        assert keys.include? 'now_playing'
        assert_song_representation parsed_response['now_playing']
      end
    end
  end

  context "Queue" do
    setup do
      @channel = Channel.make!
      @song = Song.make
      @authorized_user = User.make!(:login => 'tater')

      @channel.add(@song,@user)
      @channel.mpd.play
    end

    test "GET /queue" do
      authorized_get "/api/channels/#{@channel.id}/queue", @authorized_user
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

    test "POST /add" do
      authorized_post "/api/channels/#{@channel.id}/add", @authorized_user, {:artist_name => @song.artist.to_param, :song_name => @song.to_param, :type => 'song'}
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

    test "POST /remove" do
      @channel.add(Song.new(:path => %{Jeff Buckley/Grace/Lover, You Should've Come Over.mp3}),@user)

      authorized_post "/api/channels/#{@channel.id}/remove", @authorized_user, {:artist_name => @song.artist.to_param, :song_name => @song.to_param}
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

    test "POST /clear" do
      authorized_post "/api/channels/#{@channel.id}/clear", @authorized_user
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
