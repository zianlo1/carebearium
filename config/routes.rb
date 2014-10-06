Rails.application.routes.draw do
  root to: 'landing#show'

  get '/api/solar_systems(.:format)', to: 'solar_systems#index'

  get '*path', to: 'landing#show'
end
