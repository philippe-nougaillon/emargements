Rails.application.routes.draw do
  devise_for :users

  resources :assemblees
  resources :users
  resources :presences, only: %i[ index new create edit update destroy ]

  namespace :admin do
    get :index
    get :signature
    post :signature_do
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "presences#new"
end
