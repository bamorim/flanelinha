Rails.application.routes.draw do
  resources :trips, only: [:show, :create]
  resources :parkings, only: [:index]
  resources :cars, only: [:index, :create, :update]
end
