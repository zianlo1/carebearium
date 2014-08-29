class LandingController < ApplicationController
  def show
    render text: '', layout: true
  end

  def filter_constraints
    last_update = SolarSystem.maximum(:updated_at)
    cache_key   = "landing#filter_constraints/#{last_update.to_i}"
    if stale?(last_modified: last_update, etag: cache_key, public: true)
      constraints = Rails.cache.fetch cache_key do
        {
          security:                   { min: 5, max: 10 },
          belts:                      { min: SolarSystem.minimum(:belt_count), max: SolarSystem.maximum(:belt_count) },
          stations:                   { min: SolarSystem.minimum(:stations_count), max: SolarSystem.maximum(:stations_count) },
          agents:                     { min: SolarSystem.minimum(:agents_count), max: SolarSystem.maximum(:agents_count) },
          manufacturing_index:        { min: (SolarSystem.minimum(:manufacturing_index) * 1000).to_i, max: (SolarSystem.maximum(:manufacturing_index) * 1000).to_i },
          research_te_index:          { min: (SolarSystem.minimum(:research_te_index) * 1000).to_i, max: (SolarSystem.maximum(:research_te_index) * 1000).to_i },
          research_me_index:          { min: (SolarSystem.minimum(:research_me_index) * 1000).to_i, max: (SolarSystem.maximum(:research_me_index) * 1000).to_i },
          copying_index:              { min: (SolarSystem.minimum(:copying_index) * 1000).to_i, max: (SolarSystem.maximum(:copying_index) * 1000).to_i },
          reverse_engineering_index:  { min: (SolarSystem.minimum(:reverse_engineering_index) * 1000).to_i, max: (SolarSystem.maximum(:reverse_engineering_index) * 1000).to_i },
          invention_index:            { min: (SolarSystem.minimum(:invention_index) * 1000).to_i, max: (SolarSystem.maximum(:invention_index) * 1000).to_i },
          region:                     SolarSystem.order(:region_name).uniq.pluck(:region_name).map{ |n| { name: n }},
          agent_kind:                 Agent.order(:kind).uniq.pluck(:kind),
          agent_level:                Agent.order(:level).uniq.pluck(:level),
          agent_corporation:          Corporation.where.not(agents_count: 0).order(:name).uniq.pluck(:name)
        }
      end
      render json: constraints
    end
  end
end
