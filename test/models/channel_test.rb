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
      assert_equal  "#{Rails.root}/test/tmp/play-test/channels/channel-1", @channel.config_directory
    end

    test 'has the right mpd config path' do
      assert_equal  "#{Rails.root}/test/tmp/play-test/channels/channel-1/mpd.conf", @channel.config_path
    end

    test 'writes out the mpd config' do
      @channel.write_config
      assert File.exists?(@channel.config_path)
    end
  end
end
