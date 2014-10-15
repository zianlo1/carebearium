class LandingController < ApplicationController
  respond_to :html

  def show
    expires_in 1.hour, public: true

    @solar_system_owner_names = SolarSystemOwner.names.to_json
    @solar_system_limits = SolarSystem.limits.to_json

    render text: '', layout: 'application'
  end
end
