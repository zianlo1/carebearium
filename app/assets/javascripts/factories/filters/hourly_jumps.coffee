#= require ./slider

class CB.Filters.HourlyJumps extends CB.Filters.Slider
  scale: 10

  filterFunction: (item) =>
    val = item.hourly_jumps * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'hourly_jumps'
    text: 'Jumps / h'
    display: (item) -> item.hourly_jumps.toFixed(1)

  filterName: 'Average hourly jumps'
