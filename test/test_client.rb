require 'helper'

context "Client" do
  setup do
  end

  test "volume" do
    Client.stubs(:system).returns(true)
    Client.volume(1)
  end
end
