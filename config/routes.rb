Rails.application.routes.draw do
  get "follows/follow_user"
  get "follows/unfollow_user"
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
  resources :posts do
    resources :comments
    resources :likes, only: [:create, :destroy]

    get "likers", to: "posts#likers"
  end

  get ":user_name", to: "profiles#show", as: :profile
  get ":user_name/edit", to: "profiles#edit", as: :edit_profile
  post ":user_name/edit", to: "profiles#update", as: :update_profile
end
