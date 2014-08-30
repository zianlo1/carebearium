Rails.application.routes.draw do
  root to: 'landing#show'

  get '/constraints', to: 'landing#constraints'

  resources :solar_systems, only: [:index] do
    get :names, on: :collection
  end
end
