Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root 'transactions#index'

  resources :transactions, only: :index do
    post :sync, on: :collection
  end

  resources :currency_rates, only: :index
end
