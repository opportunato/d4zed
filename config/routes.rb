Rails.application.routes.draw do
  root 'main#index'

  mount RailsAdmin::Engine, at: '/admin'
end
