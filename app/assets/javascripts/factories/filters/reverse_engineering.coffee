#= require ./slider

class CB.Filters.ReverseEngineering extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.reverse_engineering * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'reverse_engineering'
    text: 'Reverse eng.'
    display: (item) -> item.reverse_engineering.toFixed(5)

  filterName: 'Reverse engineering index'
