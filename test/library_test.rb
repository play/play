require 'helper'

context "Library" do
  test "library enabled enumerates all when enabled" do
    found = 0
    count = Play::Library.instances.size
    assert count > 0
    
    Play::Library.instances.each do |instance|
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
    names = instances.collect{ |i| i.class.name }
    assert_equal names, ["Play::Local::Library", "Play::Rdio::Library"]
  end
  
  test "instances are the same ones" do
    first = Play::Library.instances.first
    assert_equal first, Play::Library.instances.first
  end
  
end