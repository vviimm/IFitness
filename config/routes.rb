Rails.application.routes.draw do

  devise_for :users
  resources :settings
  root to: "home#index"
end
