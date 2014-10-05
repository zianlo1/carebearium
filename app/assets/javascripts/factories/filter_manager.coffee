#= require_tree ./filters

CB.factory 'FilterManager', (Limits) ->
  filters =
    security: CB.Filters.Security

  filters
