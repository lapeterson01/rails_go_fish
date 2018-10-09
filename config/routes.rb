Rails.application.routes.draw do
  resources :sessions
  resources :users
  root 'sessions#new'
end
