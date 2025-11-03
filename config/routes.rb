Rails.application.routes.draw do
  get "profiles/show"
  devise_for :users, controllers: {registrations: "registrations"}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"
  get :explore, to: "posts#explore", as: :explore
  resources :posts do
    resources :comments
    resources :likes, only: [:create, :destroy]

    get "likers", to: "posts#likers"
  end

  get ":user_name", to: "profiles#show", as: :profile
  get ":user_name/edit", to: "profiles#edit", as: :edit_profile
  post ":user_name/edit", to: "profiles#update", as: :update_profile

  post ":user_name/follow", to: "follows#follow", as: :follow_user
  post ":user_name/unfollow", to: "follows#unfollow", as: :unfollow_user

  get "/chats/inbox", to: "chats#index"

  resources :chats, only: [:show, :create] do
    resources :messages, only: [:create]
  end

  post "/chats/start_with/:user_id", to: "chats#start_with", as: :start_chat_with
end
