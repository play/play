class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_auth

protected

  def require_auth
#     if !user_signed_in?
#       redirect_to user_omniauth_authorize_path(:github)
#     end
  end

  def render_404
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
end
