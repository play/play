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

      session[:user] = user
    end

    def current_user
      session[:user]
    end
  end
end