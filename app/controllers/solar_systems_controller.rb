class SolarSystemsController < ApplicationController
  respond_to :json

  def index
    solar_systems = SolarSystem.all

    params.fetch(:filter, {}).each do |kind, options|
      if %w(security belts stations agents).include?(kind)
        solar_systems = solar_systems.send kind, JSON.parse(options, symbolize_names: true)
      end
    end

    params.fetch(:sorting, {}).each do |column, direction|
      if SolarSystem.column_names.include?(column)
        solar_systems = solar_systems.order "#{column} #{direction.downcase == 'asc' ? 'ASC' : 'DESC'}"
      end
    end

    solar_systems = solar_systems.page(params[:page]).per(params[:count])

    render json: solar_systems
  end
end
