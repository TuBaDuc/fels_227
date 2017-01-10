Rails.application.routes.draw do
  get "sessions/new"

  get "users/new"

  get "static_pages/home"
  get "static_pages/help"
  root "static_pages#home"
  get "/help",  to: "static_pages#help"
  get "/about",  to: "static_pages#about"
  get "/contact",  to: "static_pages#contact"

  get "/login",   to: "sessions#new"
  post "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get "/signup",  to: "users#new"
  post "/signup",  to: "users#create"
  resources :users do
    resources :following, only: [:index]
    resources :followers, only: [:index]
  end
  resources :users
  resources :relationships,  only: [:create, :destroy]
end
