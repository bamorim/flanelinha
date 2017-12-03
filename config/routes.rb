Rails.application.routes.draw do
  get '/me', to: "accounts#get"
  resource :cards, only: [:create]
  resources :sessions, only: [:create]
  resources :accounts, only: [:create]
  resources :trips, only: [:show, :create] do
    TripsController::EVENTS.each do |e|
      post e
    end
  end
  resources :parkings, only: [:index]
  resources :cars, only: [:index, :create, :update]
  resources :charges, only: [:index]
end
