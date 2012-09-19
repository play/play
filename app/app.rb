module Play
  class App < Sinatra::Base
    # Include our Sinatra Helpers.
    include Play::Helpers

    register Mustache::Sinatra
    register Sinatra::Auth::Github

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Play,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }
    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    get "/" do
      @songs = Queue.songs
      mustache :index
    end
  end
end