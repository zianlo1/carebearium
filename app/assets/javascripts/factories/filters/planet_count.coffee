#= require ./slider

class CB.Filters.PlanetCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.planet_count >= @options.min and item.planet_count <= @options.max

  visibleField: ->
    field: 'planet_count'
    text: 'Planets'
    display: (item) -> item.planet_count

  filterName: 'Planet count'
