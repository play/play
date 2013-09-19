class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :auth_required, :music_required

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_login(session[:github_login])
  end

  # This is only used in the music_required thing below, TODO take it out
  def channel
    session[:channel_id] ? Channel.find(session[:channel_id]) : Play.default_channel
  end

protected

  # Everything that interacts with a queue is scoped to a channel
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end


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
  # Sets a flag for the layout to render an appropriate error message.
  def music_required
    return if Rails.env.test?
    if !channel.mpd
      @no_music = true
    elsif channel.queue.empty?
      @nothing_queued = true
    end
  end

  def render_404
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
end
