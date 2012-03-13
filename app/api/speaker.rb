module Play
  # API endpoints for Airfoil speaker controls.
  class App < Sinatra::Base

    get "/speakers" do
    	speakers = {
    		:speakers => Airfoil.get_speakers.map { |speaker| speaker.to_hash }
    	}.to_json
    end

    get "/speaker/:id" do
    	speaker = {
    		:speaker => Speaker.new(params[:id]).to_hash
    	}.to_json
    end

    put "/speaker/:id/volume" do
    	speaker = Speaker.new params[:id]
    	speaker.volume = params[:volume]
    	speaker = {
    		:speaker => speaker.to_hash
    	}.to_json
    end

    put "/speaker/:id/connect" do
    	speaker = Speaker.new params[:id]
    	speaker.connect!
    	speaker = {
    		:speaker => speaker.to_hash
    	}.to_json
    end

    put "/speaker/:id/disconnect" do
    	speaker = Speaker.new params[:id]
    	speaker.disconnect!
    	speaker = {
    		:speaker => speaker.to_hash
    	}.to_json
    end

    put "/volume" do
    	Airfoil.speakers_volume = params[:volume]
    	speakers = {
    		:speakers => Airfoil.get_speakers.map { |speaker| speaker.to_hash }
    	}.to_json
    end

  end
 end