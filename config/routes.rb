Mwiki::Application.routes.draw do
  root :to => "wikis#index"
  resources :wikis, only: [:index, :create]
  resources :users, only: [:new, :create, :show]
  resources :changes, only:[:destroy]
  resources :page_users, only: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :frames, only: [:index]
  resources :about, only: [:index]

  match "/signup", to: 'users#new', as: '/signup'
  match "/login", to: 'sessions#new', as: '/login'
  match "/logout", to: 'sessions#destroy', as: '/logout'

  get "/wiki/reconstruct/:ending", to: 'wikis#reconstruct'
  get "/wiki/:ending", to: 'wikis#revise'
end
