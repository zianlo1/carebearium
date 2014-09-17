class SolarSystemsController < ApplicationController
  respond_to :json

  def index
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "solar_systems#index/#{Digest::MD5.hexdigest params.to_s}/#{last_update.to_i}"

    if stale?(last_modified: last_update, etag: cache_key, public: true)
      finder = SolarSystemFinder.new
      finder.find_by  params[:filters]
      finder.order_by params[:order]
      render json: finder.limit(100).to_json
    end
  end

  def show
    solar_system = SolarSystem.find params[:id].to_i

    if stale? solar_system
      render json: solar_system.as_document.as_json
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
