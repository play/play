require File.expand_path("../helper", __FILE__)

if !Airfoil.installed?
	puts "\nAirfoil is not installed, skipping Airfoil tests."
	puts "You can get Airfoil from http://rogueamoeba.com/airfoil/\n\n"
end

context "Airfoil" do

  setup do
  	Airfoil.app.get
    @speaker = Speaker.new "com.rogueamoeba.airfoil.LocalSpeaker"
  end

  test "Get speakers" do
  	speakers = Airfoil.get_speakers
  	assert speakers.length > 0
  	assert_equal @speaker.id, speakers[0].id
  	assert_equal @speaker.name, speakers[0].name
    assert_equal @speaker.connected?, speakers[0].connected?
  	assert_equal @speaker.volume, speakers[0].volume
  end

  test "All speaker volumes getting and setting" do
  	speakers = Airfoil.get_speakers
  	Airfoil.speakers_volume = 0
  	speakers.each do |speaker|
  		assert_equal 0, speaker.volume
  	end

  	Airfoil.speakers_volume = 1
  	speakers.each do |speaker|
  		assert_equal 1, speaker.volume
  	end

   	Airfoil.speakers_volume = 0
  	speakers.each do |speaker|
  		assert_equal 0, speaker.volume
  	end
  end

end if Airfoil.installed? and ENV['CI'] != '1'
