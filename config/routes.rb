Rails.application.routes.draw do
  resources :sessions, only: %i[index create]
  resource :session, only: %i[destroy]
  resources :users, only: %i[create new]
  resources :games, only: %i[index show new]
  root 'sessions#index'
end
