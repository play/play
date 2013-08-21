require "active_record/validations"

class Api::BaseController < ActionController::Base
  include Play::Api::ErrorDelivery
  include Play::Api::JsonDelivery
  include Play::Api::ApiResponse

  before_filter :authentication_required

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # Public: Simple action to test API authentication.
  def test
    render :json => {:message => "Successfully Authenticated"}
  end

  # Public: Does the request have an authenticated_user?
  #
  # Returns a TrueClass or FalseClass.
  def authenticated?
    !!current_user
  end

  # Public: The currently authenticated user if one is set.
  #
  # Returns a User or NilClass.
  def current_user
    @current_user ||= find_user
  end

  private

  # Private: Require that the request has a valid authentication token.
  def authentication_required
    authenticated? || permission_denied
  end

  # Private: Halts the request with an unauthorized response.
  def permission_denied
    head :unauthorized
  end

  # Private: Finds user based on request headers
  def find_user
    token = request.headers['Authorization'] || params[:token] || ""
    login = request.headers["X_PLAY_LOGIN"] || params[:login] || ""

    if token == Play.config['auth_token']
      user = User.where(:login => login).first
    else
      user = User.find_by_token(token)
    end
  end


  # Private: Rescues all ActiveRecord::RecordNotFound errors
  # and delivers an error.
  def record_not_found(exception)
    deliver_error(404, :message => exception.message)
  end

end
