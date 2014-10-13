class LandingController < ApplicationController
  def show
    last_update = ApiLog.last_significant_update

    @solar_system_owner_names = Rails.cache.fetch "solar_system_owner_names/#{last_update.to_i}" do
      SolarSystemOwner.names.to_json
    end

    @solar_system_limits = Rails.cache.fetch "solar_system_limits/#{last_update.to_i}" do
      SolarSystem.limits.to_json
    end

    render text: '', layout: true
  end
end
