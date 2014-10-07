#= require ./slider

class CB.Filters.BeltCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.beltCount >= @options.min and item.beltCount <= @options.max

  visibleField: ->
    field: 'beltCount'
    text: 'Belts'
    display: (item) -> item.beltCount

  filterName: 'Belt count'
