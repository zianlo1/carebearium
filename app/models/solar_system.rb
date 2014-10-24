class SolarSystem
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :region_id,   type: Integer
  field :security,    type: Float
  field :belt_count,  type: Integer
  field :moon_count,  type: Integer
  field :ice,         type: Boolean
  field :owner_id,    type: Integer

  field :stations, type: Hash, default: {}
  field :agents,   type: Hash, default: {}
  field :planets,  type: Hash, default: {}

  field :jumps, type: Array, default: []

  field :manufacturing,       type: Float, default: 0.0
  field :research_te,         type: Float, default: 0.0
  field :research_me,         type: Float, default: 0.0
  field :copying,             type: Float, default: 0.0
  field :reverse_engineering, type: Float, default: 0.0
  field :invention,           type: Float, default: 0.0

  field :hourly_ships, type: Float, default: 0.0
  field :hourly_pods,  type: Float, default: 0.0
  field :hourly_npcs,  type: Float, default: 0.0
  field :hourly_jumps, type: Float, default: 0.0

  field :x, type: Float
  field :y, type: Float
  field :z, type: Float

  field :jumps_to_continous_hisec, type: Integer
  field :jumps_to_nearest_hisec,   type: Integer
  field :jumps_to_lowsec,          type: Integer
  field :jumps_to_nullsec,         type: Integer

  STATION_TYPE_OPERATIONS = {
    21642 => 48,
    21644 => 49,
    21645 => 50,
    21646 => 51
  }

  INDUSTRY_ACTIVITY_IDS = {
    1 => :manufacturing,
    3 => :research_te,
    4 => :research_me,
    5 => :copying,
    7 => :reverse_engineering,
    8 => :invention
  }

  NUMERIC_FIELDS = [
    :security, :belt_count, :manufacturing, :research_te, :research_me, :copying, :reverse_engineering, :invention,
    :hourly_ships, :hourly_pods, :hourly_npcs, :hourly_jumps, :moon_count
  ]

  LIMITS_MAP_FUNCTION = <<-JS.freeze
    function() {
      #{NUMERIC_FIELDS.map { |f| "emit('#{f}', { min: this.#{f}, max: this.#{f} })" }.join('; ')};

      var agentCount   = Object.keys(this.agents).length;
      emit('agent_count', { min: agentCount, max: agentCount });

      var stationCount = Object.keys(this.stations).length;
      emit('station_count', { min: stationCount, max: stationCount });

      var planetCount = 0;
      for (var type in this.planets) {
        planetCount += this.planets[type];
      }
      emit('planet_count', { min: planetCount, max: planetCount });

      emit('jump_count', { min: this.jumps.length, max: this.jumps.length });
    }
  JS

  LIMITS_REDUCE_FUNCTION = <<-JS.freeze
    function(key, values) {
      var result = { min: 0, max: 0 }

      for(var i in values){
        if(values[i].min < result.min){ result.min = values[i].min }
        if(values[i].max > result.max){ result.max = values[i].max }
      }

      return result;
    }
  JS

  def self.data
    all.each_with_object({}) do |system, map|
      map[system.id] = [
        system.region_id,
        system.security,
        system.belt_count,
        system.ice,
        system.stations.map{ |id, s| [s[:name], s[:operation_id]] },
        system.agents.map{ |id, a| [a[:corporation_id], a[:level], a[:division]] },
        system.jumps,
        system.manufacturing,
        system.research_te,
        system.research_me,
        system.copying,
        system.reverse_engineering,
        system.invention,
        system.hourly_ships,
        system.hourly_pods,
        system.hourly_npcs,
        system.hourly_jumps,
        system.owner_id,
        system.x,
        system.y,
        system.z,
        system.moon_count,
        system.planets
      ]
    end
  end

  def self.limits
    map_reduce(LIMITS_MAP_FUNCTION, LIMITS_REDUCE_FUNCTION).out(inline: true).js_mode.each_with_object({}) do |row,limits|
      limits[row['_id']] = row['value']
    end
  end

  def self.update_industry_indices
    ApiLog.call 'industry_indices', ->{ CREST.industry_indices } do |row|
      system = find row['solarSystem']['id']
      attrs  = {}
      row['systemCostIndices'].each do |item|
        key = INDUSTRY_ACTIVITY_IDS[item['activityID']]
        attrs[key] = item['costIndex'].to_f.round(5) unless key.nil?
      end
      system.update_attributes attrs
    end
  end

  def self.update_conquerable_stations
    ApiLog.call 'conquerable_stations', ->{ EveApi.conquerable_stations } do |row|
      system = find row['solarSystemID'].to_i
      system.stations[row['stationID'].to_i] = { name: row['stationName'], operation_id: STATION_TYPE_OPERATIONS[row['stationTypeID'].to_i] }
      system.save
    end
  end

  def self.update_sovereignty
    ApiLog.call 'sovereignty', ->{ EveApi.sovereignty }, finally: -> { SolarSystemOwner.update_names } do |row|
      system = find row['solarSystemID'].to_i

      owner_id = nil
      owner_id = row['allianceID'] unless row['allianceID'] == '0'
      owner_id ||= row['factionID'] unless row['factionID'] == '0'

      system.update_attributes(owner_id: owner_id)
    end
  end

  def self.update_aggregate_stats
    return unless ApiLog.expired? 'aggregates'

    kill_summary = KillStat.hourly_summary
    jump_summary = JumpStat.hourly_summary

    each do |solar_sytem|
      kill_stats = kill_summary[solar_sytem.id.to_i]
      jump_stats = jump_summary[solar_sytem.id.to_i]

      solar_sytem.update_attributes(
        hourly_ships: kill_stats[:ship_kills].round(1),
        hourly_pods:  kill_stats[:pod_kills].round(1),
        hourly_npcs:  kill_stats[:npc_kills].round(1),
        hourly_jumps: jump_stats[:jumps].round(1)
      )
    end

    ApiLog.log 'aggregates', (4.hours - 10.minutes).from_now
  end
end
