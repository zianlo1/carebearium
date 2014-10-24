#= require ./slider

class CB.Filters.JumpsToNullsec extends CB.Filters.Slider
  filterFunction: (item) =>
    item.jumps_to_nullsec >= @options.min and item.jumps_to_nullsec <= @options.max

  visibleField: ->
    field: 'jumps_to_nullsec'
    text: 'To nullsec'
    display: (item) -> item.jumps_to_nullsec

  filterName: 'Jumps to nullsec'
