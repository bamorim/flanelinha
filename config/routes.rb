Rails.application.routes.draw do
  resources :accounts, only: [:create]
  resources :trips, only: [:show, :create] do
    TripsController::EVENTS.each do |e|
      post e
    end
  end
  resources :parkings, only: [:index]
  resources :cars, only: [:index, :create, :update]
end
