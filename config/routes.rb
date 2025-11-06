Rails.application.routes.draw do
  root 'home#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :sidekiq, only: [] do
  end

  resources :rabbitmq, only: [] do
  end

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
end
