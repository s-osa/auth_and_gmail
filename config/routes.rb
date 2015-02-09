Rails.application.routes.draw do
  resources :users, only: [:index]

  get    "login"  => "sessions#new"
  get    "oauth2" => "sessions#oauth2"
  delete "logout" => "sessions#destroy"
  get    "logout" => "sessions#destroy"

  root "users#index"
end
