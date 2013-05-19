module EagerLoadHelper
  def current_user_likes
    @current_user_likes ||= current_user.likes
  end

  def current_playlist
    @current_playlist ||= PlayQueue.songs
  end
end