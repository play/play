require 'app/api/control'
require 'app/api/library'
require 'app/api/main'
require 'app/api/queue'

module Play
  class App < Sinatra::Base

    # Set up sessions and ensure we have a constant session_secret so that in
    # development mode `shotgun` won't regenerate a session secret and
    # invalidate all of our sessions.
    enable :sessions
    set    :session_secret, Play.config.client_id

    register Mustache::Sinatra
    register Sinatra::Auth::Github

    dir = File.dirname(File.expand_path(__FILE__))

    set :github_options, {
                            :secret    => Play.config.secret,
                            :client_id => Play.config.client_id,
                         }

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Play,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }

    before do
      session_not_required = request.path_info =~ /\/login/ ||
                             request.path_info =~ /\/auth/

      if session_not_required || session[:user]
        true
      else
        session[:user] = authenticate!
      end
    end

    get "/" do
      mustache :index
    end

  end
end
