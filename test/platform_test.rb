require 'helper'

context "Platform" do
  setup do
  end

  test "darwin?" do
    assert_equal RUBY_PLATFORM.include?('darwin'), Play::Platform.darwin?
  end

  test "linux?" do
    assert_equal RUBY_PLATFORM.include?('linux'), Play::Platform.linux?
  end

  test "windows?" do
    assert_equal RUBY_PLATFORM.include?('mswin') ||
                 RUBY_PLATFORM.include?('mingw'), Play::Platform.windows?
  end

  test "play_command" do
    Play::Platform.stubs(:warn).returns(true)
    assert_equal "afplay", Play::Platform.play_command if RUBY_PLATFORM.include?('darwin')
    assert_equal "play", Play::Platform.play_command if RUBY_PLATFORM.include?('linux')

    assert_equal 1, Play::Platform.play_command if RUBY_PLATFORM.include?('mswin') ||
                                                   RUBY_PLATFORM.include?('mingw')
  end

  test "say_command on darwin" do
    if RUBY_PLATFORM =~ /darwin/
      assert_equal "say", Play::Platform.say_command
    end
  end

#  test "say_command on linux" do
#    if RUBY_PLATFORM =~ /linux/
#      assert_equal "", Play::Platform.say_command
#    end
#  end

  test "volume_command on darwin" do
    if RUBY_PLATFORM =~ /darwin/
      assert_equal "osascript -e 'set volume 2' 2>/dev/null", Play::Platform.volume_command(2)
    end
  end

  test "volume_command on linux" do
    if RUBY_PLATFORM =~ /linux/
      assert_equal "amixer set Master 20%", Play::Platform.volume_command(2)
    end
  end
end
