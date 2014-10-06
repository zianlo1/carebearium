#= require ./slider

class CB.Filters.HourlyShips extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.hourly_ships * @scale
    val >= @options.min and val <= @options.max

  visibleFields: ->
    hourly_ships:
      text: 'Ship kills'
      display: (item) -> item.hourly_ships.toFixed(5)

  filterName: 'Average hourly ship kills'
