#= require ./base

class CB.Filters.Security extends CB.Filters.Base
  filterFunction: (item) =>
    item.security >= @options.min and item.security <= @options.max

  visibleFields: ->
    security:
      text: 'Security'
      sorted: false
      display: (item) -> item.security.toFixed(1)
