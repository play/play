module EagerLoadHelper
  def current_user_likes
    @current_user_likes ||= current_user.likes
  end

  def current_playlist
    @current_playlist ||= Play.default_channel.queue
  end
end
