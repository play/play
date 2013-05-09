module Play
  module AuthenticationHelper
    def authenticate
      org = Play.config['github']['org']
      if org.present?
        github_organization_authenticate!(org)
      else
        authenticate!
      end

      user   = User.find_by_login(github_user.login)
      user ||= User.create(:login => github_user.login, :email => github_user.email)

      halt 401 if !user

      session[:user_id] = user.id
    end

    def current_user
      return if !session[:user_id]

      @current_user ||= User.find(session[:user_id])
    end
  end
end