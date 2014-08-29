class SolarSystemsController < ApplicationController
  respond_to :json

  def index
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "solar_systems#index/#{Digest::MD5.hexdigest params.to_s}/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      results = Rails.cache.fetch cache_key do
        solar_systems = SolarSystem.all

        # params.fetch(:filter, {}).each do |kind, options|
        #   if SolarSystemFinders.public_instance_methods.map(&:to_s).include?(kind)
        #     solar_systems = solar_systems.send kind, JSON.parse(options, symbolize_names: true)
        #   end
        # end
        #
        # params.fetch(:sorting, {}).each do |column, direction|
        #   if SolarSystem.column_names.include?(column)
        #     solar_systems = solar_systems.order "#{column} #{direction.downcase == 'asc' ? 'ASC' : 'DESC'}"
        #   end
        # end

        solar_systems.page(params[:page]).per(params[:count]).to_a
      end

      render json: results
    end
  end

  def names
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "solar_systems#names/#{params[:q]}/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      results = SolarSystem.where(name: /#{Regexp.quote params[:q].to_s}/i).order(:name.asc).limit(25)
      render json: results.map { |r| { id: r.id, name: r.name } }
    end
  end
end
