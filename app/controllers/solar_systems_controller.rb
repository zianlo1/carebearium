class SolarSystemsController < ApplicationController
  respond_to :json

  def index
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "solar_systems#index/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      json = Rails.cache.fetch cache_key do
        SolarSystem.data.to_json
      end
      render json: json
    end
  end
end
