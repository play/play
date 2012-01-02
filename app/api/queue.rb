module Play
  class App < Sinatra::Base

    get "/queue" do
      Queue.to_json
    end
    
  end
end