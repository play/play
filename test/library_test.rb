require 'helper'

context "Library" do
  test "library enabled enumerates all when enabled" do
    found = 0
    count = Play::Library.instances.size
    assert count > 0
    
    Play::Library.instances.values.each do |instance|
      instance.stubs(:enabled?).returns(true)
    end
    
    Play::Library.enabled do |library|
      assert library.enabled?
      found +=1
    end
    assert count == found
  end
  
  test "instances returns all" do
    instances = Play::Library.instances
    assert_equal instances.keys.sort, ["Play::Local::Library", "Play::Rdio::Library"]
  end
  
  test "instances are the same ones" do
    first = Play::Library.instances.values.first
    assert_equal first, Play::Library.instances.values.first
  end
  
  test "instance finds the instances" do
    instance = Play::Library.instance("Play::Local::Library")
    assert instance.class.name == "Play::Local::Library"
  end
  
end