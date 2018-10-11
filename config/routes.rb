Rails.application.routes.draw do
  resources :sessions, only: %i[index create]
  resources :users, only: %i[create new]
  resources :games, only: %i[index show]
  root 'sessions#index'
end
