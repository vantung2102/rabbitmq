Rails.application.routes.draw do
  root 'home#index'
  # get 'demo', to: 'home#demo'

  # Demo routes
  resources :demo, only: [:index] do
    collection do
      # Sidekiq demo actions
      post :send_email
      post :process_image
      # RabbitMQ demo actions
      post :create_order
      post :paid_order
      post :shipped_order
      post :direct_exchange_demo
      post :headers_exchange_demo
      get :stats
    end
  end

  # Sidekiq Web UI
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users,
    controllers: {
      sessions: 'authentication/sessions',
      registrations: 'authentication/registrations',
      omniauth_callbacks: 'authentication/omniauth_callbacks'
    }

  namespace :admin do
    resources :users

    root to: 'users#index'
  end
end
