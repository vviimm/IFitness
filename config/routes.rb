Rails.application.routes.draw do

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:index, :destroy]
  resources :settings
  root to: "home#index"
end
