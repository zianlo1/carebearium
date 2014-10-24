#= require ./slider

class CB.Filters.JumpsToLowsec extends CB.Filters.Slider
  filterFunction: (item) =>
    item.jumps_to_lowsec >= @options.min and item.jumps_to_lowsec <= @options.max

  visibleField: ->
    field: 'jumps_to_lowsec'
    text: 'To lowsec'
    display: (item) -> item.jumps_to_lowsec

  filterName: 'Jumps to lowsec'
