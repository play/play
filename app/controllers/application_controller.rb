class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :auth_required, :music_required

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_login(session[:github_login])
  end


protected

  # We require login to use Play. deal_with_it.gif.
  #
  # Redirects to the login page if the user isn't logged in.
  def auth_required
    if !current_user
      session[:return_to] = request.url
      redirect_to '/auth/github'
    end
  end

  # Checks to see if the music server is set up correctly.
  #
  # Redirects to an appropriate error page if something is fubar.
  def music_required
    return if Rails.env.test?

    if !Play.mpd.connected?
      return render :template => 'shared/no_music'
    elsif PlayQueue.songs.empty?
      return render :template => 'shared/nothing_queued'
    end
  end

  def render_404
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
end
