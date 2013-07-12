Play::Application.routes.draw do

  get "search" => 'songs#search'
  get "artists/:artist_name/songs/:title" => 'songs#show', :as => 'song'
  get "artists/:artist_name/albums/:name" => 'albums#show', :as => 'album'
  get "artists/:artist_name/songs" => 'artists#songs', :as => 'artist_songs'
  get "artists/:artist_name" => 'artists#show', :as => 'artist'
  get "images/art/:id.png" => 'images#art'

  get 'artists/:artist_name/albums/:name/download' => 'albums#download', :as => 'album_download'
  get 'songs/download/*path' => 'songs#download', :format => false, :as => 'song_download'
  post 'songs' => 'songs#create'

  get ':login/likes' => 'likes#index'

  resources :likes do
  end

  resources :queue do
  end

  scope '/likes' do
    delete ''          => 'likes#destroy'
  end

  scope '/queue' do
    delete ''          => 'queue#destroy'
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure'         => 'sessions#failure'
  get '/logout'               => 'sessions#logout'

  # API Routes
  namespace :api do
    # users
    get "/users" => 'users#index', :as => 'users'
    get "/users/:login" => 'users#show', :as => 'user'
    get "/users/:login/likes" => 'users#likes', :as => 'likes_user'

    # artists
    get "/artists" => 'artists#index', :as => 'artists'
    get "/artists/:artist_name" => 'artists#show', :as => 'artist'

    # albums
    get "/artists/:artist_name/albums" => 'albums#index', :as => 'artist_albums'
    get "/artists/:artist_name/albums/:album_name" => 'albums#show', :as => 'artist_album'
    get "/artists/:artist_name/albums/:album_name/download" => 'albums#download', :as => 'download_artist_album'

    # songs
    get "/songs/:song_name" => 'songs#show', :as => 'song'
    get "/songs/:song_name/download" => 'songs#download', :as => 'download_song'
    put "/songs/:song_name/like" => 'songs#like', :as => 'like_song'
    put "/songs/:song_name/unlike" => 'songs#unlike', :as => 'unlike_song'

    # controls
    post "/play" => 'controls#play', :as => 'play'
    post "/pause" => 'controls#pause', :as => 'pause'
    post "/next" => 'controls#next', :as => 'next'

    # queue
    get "/now_playing" => 'queue#now_playing', :as => 'now_playing'
    get "/queue" => 'queue#list', :as => 'queue'
    post "/queue/add" => 'queue#add', :as => 'add_queue'
    post "/queue/remove" => 'queue#remove', :as => 'remove_queue'
    post "/queue/clear" => 'queue#clear', :as => 'clear_queue'

    get "/" => "base#test"
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'queue#index'

  get '/:login' => 'users#show'
  get '/:login/history' => 'users#history'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
