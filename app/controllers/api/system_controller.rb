class Api::SystemController < Api::BaseController

  def stream
    redirect_to "#{request.scheme}://#{request.host}:8000"
  end

  def upload
  end


end
