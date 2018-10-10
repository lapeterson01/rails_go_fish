Rails.application.routes.draw do
  resources :sessions, only: [:index, :create]
  resources :users, only: [:index, :create, :new]
  root 'sessions#index'
end
