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
  resources :orders, only: [:create] do
    collection do
      post :logger
      post :payment
      post :shipping
      post :export
    end
  end
end
