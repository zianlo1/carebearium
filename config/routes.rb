Rails.application.routes.draw do
  root to: 'landing#show'

  resources :solar_systems, only: [:index, :show] do
    get :names, on: :collection
  end

  get '*path', to: 'landing#show'
end
