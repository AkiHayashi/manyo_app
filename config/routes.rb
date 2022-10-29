Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :labels, only: %i[new create edit update index destroy]
  resources :sessions, only: %i[new create destroy]
  resources :users, only: %i[new create show edit update]
  namespace :admin do
    resources :users
  end
end
