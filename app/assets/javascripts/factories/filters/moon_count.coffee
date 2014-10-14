#= require ./slider

class CB.Filters.MoonCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.moon_count >= @options.min and item.moon_count <= @options.max

  visibleField: ->
    field: 'moon_count'
    text: 'Moons'
    display: (item) -> item.moon_count

  filterName: 'Moon count'
