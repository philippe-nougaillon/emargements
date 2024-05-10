Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    authenticated :user do
      root 'admin#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # Mount Mission Control Job's engine where you wish to have it accessible
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resources :assemblees do
    member do
      get :envoyer_lien_gestionnaire
    end
  end
  resources :users
  resources :presences, only: %i[ index destroy ]
  resources :organisations, only: %i[ edit update ]
  resources :mail_logs, only: %i[ index show ]

  namespace :admin do
    get :index
    get :signature_collective
    post :signature_collective_do
    get :signature_individuelle
    post :signature_individuelle_do
    get :import
    post :import_do
    get :audits
    get :premium
    get :create_new_admin
    post :create_new_admin_do
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
