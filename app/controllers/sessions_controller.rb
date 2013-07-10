class SessionsController < ApplicationController
  skip_before_filter :auth_required, :only => [:create, :failure, :logout]

  def create
    auth = request.env['omniauth.auth']
    org = Play.config['github']['org']

    if org.present?
      client = Octokit::Client.new(:login => auth.info.nickname, :token => auth.token)
      orgs   = client.organizations(auth.info.nickname).map(&:login)

      if !orgs.include?(org)
        return render :action => :failure
      end
    end

    @user = User.find_for_github_oauth(auth)

    if @user.persisted?
      session[:github_login] = @user.login
      url = session[:return_to] ? session[:return_to] : root_url
      session[:return_to] = nil
      session.delete(:return_to)
      redirect_to url and return
    end

    render :action => :failure
  end

  def failure
    render :layout => false
  end

  def logout
    session[:github_login] = ""
    session.delete(:github_login)
    redirect_to '/'
  end

end
