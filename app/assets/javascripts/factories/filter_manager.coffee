#= require_tree ./filters

CB.factory 'FilterManager', ->
  filters =
    security:                 CB.Filters.Security
    belt_count:               CB.Filters.BeltCount
    station_count:            CB.Filters.StationCount
    agent_count:              CB.Filters.AgentCount
    copying:                  CB.Filters.Copying
    invention:                CB.Filters.Invention
    manufacturing:            CB.Filters.Manufacturing
    research_me:              CB.Filters.ResearchME
    research_te:              CB.Filters.ResearchTE
    jump_count:               CB.Filters.JumpCount
    hourly_npcs:              CB.Filters.HourlyNpcs
    hourly_pods:              CB.Filters.HourlyPods
    hourly_ships:             CB.Filters.HourlyShips
    hourly_jumps:             CB.Filters.HourlyJumps
    station_service:          CB.Filters.StationService
    system_feature:           CB.Filters.SystemFeature
    region:                   CB.Filters.Region
    agent:                    CB.Filters.Agent
    distance_jumps:           CB.Filters.DistanceJumps
    distance_lightyears:      CB.Filters.DistanceLightyears
    owner:                    CB.Filters.Owner
    moon_count:               CB.Filters.MoonCount
    planet_count:             CB.Filters.PlanetCount
    planet:                   CB.Filters.Planet
    jumps_to_lowsec:          CB.Filters.JumpsToLowsec
    jumps_to_nullsec:         CB.Filters.JumpsToNullsec
    jumps_to_continous_hisec: CB.Filters.JumpsToContinousHisec
    jumps_to_nearest_hisec:   CB.Filters.JumpsToNearestHisec
    local_pirates:            CB.Filters.LocalPirates

  for key, value of CB.StaticData.Limits
    filters[key]?.prototype.limits = value

  filters
