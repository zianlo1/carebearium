#= require ./slider

class CB.Filters.JumpsToNearestHisec extends CB.Filters.Slider
  filterFunction: (item) =>
    item.jumps_to_nearest_hisec >= @options.min and item.jumps_to_nearest_hisec <= @options.max

  visibleField: ->
    field: 'jumps_to_nearest_hisec'
    text: 'To hisec'
    display: (item) -> item.jumps_to_nearest_hisec

  filterName: 'Jumps to hisec (including islands)'
