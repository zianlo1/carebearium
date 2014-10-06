#= require_tree ./filters

CB.factory 'FilterManager', ->
  filters =
    security: CB.Filters.Security

  for key, value of CB.Limits
    filters[key]?.prototype.limits = value

  filters
