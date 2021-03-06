#= require ./slider

class CB.Filters.HourlyShips extends CB.Filters.Slider
  scale: 10

  filterFunction: (item) =>
    val = item.hourly_ships * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'hourly_ships'
    text: 'Ship kills / h'
    display: (item) -> item.hourly_ships.toFixed(1)

  filterName: 'Average hourly ship kills'
