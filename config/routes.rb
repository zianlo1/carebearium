Rails.application.routes.draw do
  root to: 'landing#show'

  get '/constraints', to: 'landing#filter_constraints'

  resources :solar_systems, only: [:index, :show]
end
