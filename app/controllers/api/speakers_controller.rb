class Api::SpeakersController < Api::BaseController

  before_filter :find_speaker

  def index
    deliver_json(200, speakers_response(Play.speakers))
  end

  def update_volume
    @speaker.set_volume(params[:level]) if @speaker
    deliver_json(200, {:message => 'ok'})
  end

  def mute
    @speaker.mute if @speaker
    deliver_json(200, {:message => 'ok'})
  end

  def unmute
    @speaker.unmute if @speaker
    deliver_json(200, {:message => 'ok'})
  end

  private

  def find_speaker
    @speaker = Play.speakers.detect{|s| s.slug == params[:speaker_name]} if params[:speaker_name]
  end

end
