#= require ./slider

class CB.Filters.Manufacturing extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.manufacturing * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'manufacturing'
    text: 'Manufacturing'
    display: (item) -> item.manufacturing.toFixed(5)

  filterName: 'Manufacturing index'
