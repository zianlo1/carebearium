#= require_tree ./filters

CB.factory 'FilterManager', ->
  filters =
    security: CB.Filters.Security
    belt_count: CB.Filters.BeltCount
    station_count: CB.Filters.StationCount
    agent_count: CB.Filters.AgentCount
    copying: CB.Filters.Copying
    invention: CB.Filters.Invention
    manufacturing: CB.Filters.Manufacturing
    research_me: CB.Filters.ResearchME
    research_te: CB.Filters.ResearchTE
    reverse_engineering: CB.Filters.ReverseEngineering

  for key, value of CB.Limits
    filters[key]?.prototype.limits = value

  filters

# hourly_npcs: Object
# hourly_pods: Object
# hourly_ships: Object
# jump_count: Object
