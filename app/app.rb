require 'app/api/control'
require 'app/api/library'
require 'app/api/main'
require 'app/api/queue'

module Play
  class App < Sinatra::Base
    enable  :sessions
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
    #  authenticate!
    end

    get "/" do
      mustache :index
    end
  end
end