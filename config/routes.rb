Rails.application.routes.draw do
  root to: 'landing#show'

  resources :solar_systems, only: [:index] do
    get :names, on: :collection
  end
end
