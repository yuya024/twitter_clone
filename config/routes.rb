# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :homes, only: %i[index show]
  resources :profiles, only: %i[show edit update]
  resources :tweets, only: %i[create show] do
    resources :comments, only: %i[index create]
    resource :favorite, only: %i[create destroy]
    resource :retweet, only: %i[create destroy]
  end
  root to: 'homes#index'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  # resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
