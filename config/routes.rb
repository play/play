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
