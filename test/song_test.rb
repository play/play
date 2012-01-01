require File.expand_path("../helper", __FILE__)

context "Song" do

  setup do
    @song = Song.new(:artist => 'Justice', :title => 'Stress')
  end

end
