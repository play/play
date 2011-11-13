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
    Platform.stubs(:warn).returns(true)
    assert_equal RUBY_PLATFORM.include?('mswin') ||
                 RUBY_PLATFORM.include?('mingw'), Play::Platform.windows?
  end
end
