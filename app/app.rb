require 'app/api/control'
require 'app/api/library'
require 'app/api/main'
require 'app/api/queue'

module Play
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Play,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }

    get "/" do
      mustache :index
    end
  end
end