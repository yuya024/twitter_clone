# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :homes
  root to: 'homes#index'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  # resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
