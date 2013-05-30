class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_auth

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_login(session[:github_login])
  end

protected


  def require_auth
    if !current_user
      session[:return_to] = request.url
      redirect_to '/auth/github'
    end
  end

  def render_404
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
end
