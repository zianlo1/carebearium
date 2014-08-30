class LandingController < ApplicationController
  def show
    render text: '', layout: true
  end

  def constraints
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "landing#constraints/#{last_update.to_i}"
    if stale?(last_modified: last_update, etag: cache_key, public: true)
      results = Rails.cache.fetch cache_key do
        constraints = {}

        SolarSystem::SCALED_FIELDS.map do |field, scale|
          constraints[field] = { min: (SolarSystem.min(field) * scale).to_i, max: (SolarSystem.max(field) * scale).to_i }
        end

        constraints[:region]            = SolarSystem.distinct(:region_name).sort.map{ |n| { name: n }}
        constraints[:agent_kind]        = SolarSystem.distinct('agents.kind').sort
        constraints[:agent_level]       = SolarSystem.distinct('agents.level').sort
        constraints[:agent_corporation] = SolarSystem.distinct('agents.corporation_name').sort

        constraints
      end
      render json: results
    end
  end
end
