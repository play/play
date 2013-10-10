module ApplicationHelper
  def current_channel
    @channel ||= session[:channel_id] ? Channel.find(session[:channel_id]) : Play.default_channel
  end
end
