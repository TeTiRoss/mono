Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'
end
