Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root 'currency_rates#index'

  resources :transactions, only: :index
end
