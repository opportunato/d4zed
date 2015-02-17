Rails.application.routes.draw do
  root 'main#index'

  mount RailsAdmin::Engine, at: '/admin'

  resources :user_sessions

  match 'login', to: 'user_sessions#new', via: :get
end
