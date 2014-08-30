class LandingController < ApplicationController
  def show
    render text: '', layout: true
  end

  def filter_constraints
    last_update = SolarSystem.max(:updated_at)
    cache_key   = "landing#filter_constraints/#{last_update.to_i}"
    if stale?(last_modified: last_update, etag: cache_key, public: true)
      constraints = Rails.cache.fetch cache_key do
        {
          security:                   { min: 5, max: 10 },
          belts_count:                { min: SolarSystem.min(:belts_count), max: SolarSystem.max(:belts_count) },
          stations_count:             { min: SolarSystem.min(:stations_count), max: SolarSystem.max(:stations_count) },
          agents_count:               { min: SolarSystem.min(:agents_count), max: SolarSystem.max(:agents_count) },
          manufacturing_index:        { min: (SolarSystem.min(:manufacturing_index) * 1000).to_i, max: (SolarSystem.max(:manufacturing_index) * 1000).to_i },
          research_te_index:          { min: (SolarSystem.min(:research_te_index) * 1000).to_i, max: (SolarSystem.max(:research_te_index) * 1000).to_i },
          research_me_index:          { min: (SolarSystem.min(:research_me_index) * 1000).to_i, max: (SolarSystem.max(:research_me_index) * 1000).to_i },
          copying_index:              { min: (SolarSystem.min(:copying_index) * 1000).to_i, max: (SolarSystem.max(:copying_index) * 1000).to_i },
          reverse_engineering_index:  { min: (SolarSystem.min(:reverse_engineering_index) * 1000).to_i, max: (SolarSystem.max(:reverse_engineering_index) * 1000).to_i },
          invention_index:            { min: (SolarSystem.min(:invention_index) * 1000).to_i, max: (SolarSystem.max(:invention_index) * 1000).to_i },
          region:                     SolarSystem.distinct(:region_name).sort.map{ |n| { name: n }},
          agent_kind:                 SolarSystem.distinct('agents.kind').sort,
          agent_level:                SolarSystem.distinct('agents.level').sort,
          agent_corporation:          SolarSystem.distinct('agents.corporation_name').sort
        }
      end
      render json: constraints
    end
  end
end
