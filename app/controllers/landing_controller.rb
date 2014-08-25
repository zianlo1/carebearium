class LandingController < ApplicationController
  def show
    render text: '', layout: true
  end

  def filter_constraints
    render json: {
      security: { min: 40, max: 100 },
      belts:    { min: SolarSystem.minimum(:belt_count), max: SolarSystem.maximum(:belt_count) },
      stations: { min: SolarSystem.minimum(:stations_count), max: SolarSystem.maximum(:stations_count) },
      agents:   { min: SolarSystem.minimum(:agents_count), max: SolarSystem.maximum(:agents_count) }
    }
  end
end
