Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      root 'presences#new', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :assemblees do
    member do
      get :commencer
    end
  end
  resources :users
  resources :presences, only: %i[ index new create edit update destroy ]
  resources :organisations, only: %i[ edit update ]
  resources :mail_logs, only: %i[ index show ]

  namespace :admin do
    get :index
    get :signature
    post :signature_do
    get :import
    post :import_do
    get :audits
    get :premium
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"

  # Defines the root path route ("/")
  root "presences#new"
end
