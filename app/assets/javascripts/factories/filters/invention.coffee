#= require ./slider

class CB.Filters.Invention extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.invention * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'invention'
    text: 'Invention'
    display: (item) -> item.invention.toFixed(5)

  filterName: 'Invention index'
