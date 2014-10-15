class SolarSystemsController < ApplicationController
  respond_to :json

  def index
    expires_in 1.hour, public: true

    render json: SolarSystem.data.to_json
  end
end
