class LandingController < ApplicationController
  respond_to :html

  def show
    last_update = ApiLog.last_significant_update
    cache_key   = "landing#show/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      @solar_system_owner_names = Rails.cache.fetch "solar_system_owner_names/#{last_update.to_i}" do
        SolarSystemOwner.names.to_json
      end

      @solar_system_limits = Rails.cache.fetch "solar_system_limits/#{last_update.to_i}" do
        SolarSystem.limits.to_json
      end

      render text: '', layout: 'application'
    end
  end
end
