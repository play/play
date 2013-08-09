class Api::SpeakersController < Api::BaseController

  before_filter :find_speaker

  def index
    deliver_json(200, speakers_response(Play.speakers))
  end

  def update_volume
    @speaker.set_volume(params[:level])
    deliver_json(200, speaker_response(@speaker))
  end

  def mute
    @speaker.mute
    deliver_json(200, speaker_response(@speaker))
  end

  def unmute
    @speaker.unmute
    deliver_json(200, speaker_response(@speaker))
  end

  private

  def find_speaker
    if params[:speaker_name]
      @speaker = Play.speakers.detect{|s| s.slug == params[:speaker_name]}
      deliver_error(404, "That speaker can not be found.") unless @speaker
    end
  end

end
