# frozen_string_literal: true

Rails.application.routes.draw do
  post '/signin', to: 'sessions#signin'
  get '/lobby',   to: 'game#lobby'
  root 'game#home'
end
