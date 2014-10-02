class SolarSystemsController < ApplicationController
  respond_to :json

  def index
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "solar_systems#index/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      render json: SolarSystem.dynamic_data.to_json
    end
  end

  def limits
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "solar_systems#limits/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      render json: SolarSystem.dynamic_limits.to_json
    end
  end
end
