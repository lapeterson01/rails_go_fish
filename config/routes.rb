Rails.application.routes.draw do
  resources :sessions, only: %i[index create]
  resources :users, only: %i[index create new]
  root 'sessions#index'
end
