#= require ./slider

class CB.Filters.Copying extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.copying * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'copying'
    text: 'Copying'
    display: (item) -> item.copying.toFixed(5)

  filterName: 'Copying index'
