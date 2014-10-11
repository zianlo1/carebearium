#= require ./slider

class CB.Filters.BeltCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.belt_count >= @options.min and item.belt_count <= @options.max

  visibleField: ->
    field: 'belt_count'
    text: 'Belts'
    display: (item) -> item.belt_count

  filterName: 'Belt count'
