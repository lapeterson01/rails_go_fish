Rails.application.routes.draw do
  resources :sessions,   only: %i[index create]
  resource :session,     only: %i[destroy]
  resources :users,      only: %i[create new]
  resources :games,      only: %i[index show new create update]
  put '/join',           to: 'games#join'
  post '/select-player', to: 'games#select_player'
  post '/select-card',   to: 'games#select_card'
  post '/play-round',    to: 'games#play_round'
  post '/set-socket-id', to: 'application#socket_id'
  root 'sessions#index'
end
