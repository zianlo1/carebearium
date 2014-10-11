#= require_tree ./filters

CB.factory 'FilterManager', ->
  filters =
    security:             CB.Filters.Security
    belt_count:           CB.Filters.BeltCount
    station_count:        CB.Filters.StationCount
    agent_count:          CB.Filters.AgentCount
    copying:              CB.Filters.Copying
    invention:            CB.Filters.Invention
    manufacturing:        CB.Filters.Manufacturing
    research_me:          CB.Filters.ResearchME
    research_te:          CB.Filters.ResearchTE
    reverse_engineering:  CB.Filters.ReverseEngineering
    jump_count:           CB.Filters.JumpCount
    hourly_npcs:          CB.Filters.HourlyNpcs
    hourly_pods:          CB.Filters.HourlyPods
    hourly_ships:         CB.Filters.HourlyShips
    hourly_jumps:         CB.Filters.HourlyJumps
    station_service:      CB.Filters.StationService
    system_feature:       CB.Filters.SystemFeature
    region:               CB.Filters.Region
    agent:                CB.Filters.Agent
    distance_jumps:       CB.Filters.DistanceJumps
    owner:                CB.Filters.Owner

  for key, value of CB.StaticData.Limits
    filters[key]?.prototype.limits = value

  filters
