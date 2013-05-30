module Play
  class Api < Sinatra::Base

    before do
      content_type :json
      error 401 unless current_user
    end

    def current_user
      @current_user ||= find_user
    end

    def find_user
      token = request.env["HTTP_AUTHENTICATION"] || params[:token] || ""
      login = request.env["HTTP_X_PLAY_LOGIN"] || params[:login] || ""

      if token == Play.config['auth_token']
        user = User.find(login)
      else
        user = User.find_by_token(token)
      end
    end

  end
end
