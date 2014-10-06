#= require_tree ./filters

CB.factory 'FilterManager', ->
  filters =
    security: CB.Filters.Security
    belt_count: CB.Filters.BeltCount
    station_count: CB.Filters.StationCount
    agent_count: CB.Filters.AgentCount

  for key, value of CB.Limits
    filters[key]?.prototype.limits = value

  filters

# jump_count: Object…a
# copying: Object
# hourly_npcs: Object
# hourly_pods: Object
# hourly_ships: Object
# invention: Object
# jump_count: Object
# manufacturing: Object
# research_me:
# research_te: Object
# reverse_engineering: Object
# station_count:
