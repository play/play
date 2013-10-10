require 'test_helper'

class ChannelTest < ActiveSupport::TestCase

  context "when creating" do
    setup do
      @channel = Channel.create(:name => 'Floor 2', :color => 'red')
    end

    test "generated an mpd_port" do
      assert_equal 6601, @channel.mpd_port
    end

    test "generated an httpd_port" do
      assert_equal 8001, @channel.httpd_port
    end
  end

  context "mpd config file" do
    setup do
      @channel = Channel.make
    end

    test 'has the right config_directory' do
      assert_equal  "#{Rails.root}/test/tmp/play-test/channels/channel-20", @channel.config_directory
    end

    test 'has the right mpd config path' do
      assert_equal  "#{Rails.root}/test/tmp/play-test/channels/channel-20/mpd.conf", @channel.config_path
    end

    test 'has the right mpd config path' do
      assert_equal  "#{Rails.root}/test/tmp/play-test/channels/channel-20/mpd.pid", @channel.pid_path
    end

    test 'writes out the mpd config' do
      @channel.write_config
      assert File.exists?(@channel.config_path)
    end
  end

  context "queue management" do
    setup do
      @channel = Channel.make
      @channel.mpd.clear
      @song = Song.make
      @user = User.make
      @channel.add(@song,@user)
    end

    test "has songs" do
      song = @channel.queue.first
      assert_equal 1, @channel.queue.size
      assert_equal 'Stress', song.title
    end

    test "can get the current song" do
      @channel.mpd.play
      song = @channel.now_playing
      assert_equal @song.title, song.title
    end

    test "clears the queue" do
      assert_equal 1, @channel.queue.size
      @channel.clear
      assert_equal 0, @channel.queue.size
    end

    test "adds a song" do
      # setup() handles adding

      assert_equal 1, @channel.queue.size
      assert_equal 1, @channel.song_plays.size
    end

    test "adds a song without a user" do
      @channel.mpd.clear
      @channel.add(@song,nil)

      assert_equal 1, @channel.queue.size
      assert_equal 2, @channel.song_plays.size
    end

    test "removes a song" do
      @channel.remove(@song,@user)

      assert_equal 0, @channel.queue.size
    end
  end

  test "to_hash" do
    channel = Channel.make
    channel_hash = channel.to_hash

    hash_keys = channel_hash.keys
    assert_equal 4, hash_keys.size
    assert hash_keys.include?(:name)
    assert hash_keys.include?(:color)
    assert hash_keys.include?(:now_playing)
    assert hash_keys.include?(:slug)
  end

end
