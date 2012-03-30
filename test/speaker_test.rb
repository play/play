require File.expand_path("../helper", __FILE__)

unless Airfoil.installed?
	puts "\nAirfoil is not installed, skipping Speaker tests."
	puts "You can get Airfoil from http://rogueamoeba.com/airfoil/\n\n"
end

context "Speaker" do

  setup do
  	Airfoil.app.get
    @speaker = Speaker.new "com.rogueamoeba.airfoil.LocalSpeaker"
  end

  test "speaker id is set" do
    assert_equal "com.rogueamoeba.airfoil.LocalSpeaker", @speaker.id
  end

  test "get speaker name" do
    assert_equal "Computer", @speaker.name
  end

  test "Speaker volume setting and getting" do
    @speaker.volume = 0
    assert_equal 0, @speaker.volume

    @speaker.volume = 1
    assert_equal 1, @speaker.volume
  end

  test "speaker connect, disconnect and connected status" do
    @speaker.disconnect!
    assert_equal false, @speaker.connected?

    @speaker.connect!
    assert @speaker.connected?

    @speaker.disconnect!
    assert_equal false, @speaker.connected?
  end

  test "speaker to hash" do
    speaker = @speaker.to_hash
    assert_equal @speaker.id, speaker[:id]
    assert_equal @speaker.name, speaker[:name]
    assert_equal @speaker.connected?, speaker[:connected]
    assert_equal @speaker.volume, speaker[:volume]
  end

  test "speaker valid_id?" do
    assert Speaker.valid_id?(@speaker.id)
    assert_equal false, Speaker.valid_id?("wtf_invalid_speaker_id_4815162342")
  end

end if Airfoil.installed? and ENV['CI'] != '1'
