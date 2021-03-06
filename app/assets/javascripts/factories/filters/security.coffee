#= require ./slider

class CB.Filters.Security extends CB.Filters.Slider
  scale: 10

  filterFunction: (item) =>
    val = item.security * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'security'
    text: 'Security'
    display: (item) -> item.security.toFixed(1)

  filterName: 'Security'
