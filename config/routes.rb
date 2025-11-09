Rails.application.routes.draw do
  root 'home#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Demo routes
  resources :demo, only: [:index] do
    collection do
      get :stats
    end
  end

  # Sidekiq routes
  resources :sidekiqs, only: [] do
    collection do
      post :send_email
      post :process_image
    end
  end

  # RabbitMQ routes
  resources :rabbitmq, only: [] do
    collection do
      post :create_order
      post :paid_order
      post :shipped_order
      post :direct_exchange_demo
      post :headers_exchange_demo
    end
  end
end
