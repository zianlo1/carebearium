#= require ./slider

class CB.Filters.JumpCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.jumps.length >= @options.min and item.jumps.length <= @options.max

  mapFunction: (item) ->
    item.jumpCount = item.jumps.length
    item

  visibleField: ->
    field: 'jumpCount'
    text: 'Adjacent systems'
    display: (item) -> item.jumpCount

  filterName: 'Adjacent system count'
