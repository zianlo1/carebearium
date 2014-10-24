#= require ./slider

class CB.Filters.JumpsToContinousHisec extends CB.Filters.Slider
  filterFunction: (item) =>
    item.jumps_to_continous_hisec >= @options.min and item.jumps_to_continous_hisec <= @options.max

  visibleField: ->
    field: 'jumps_to_continous_hisec'
    text: 'To continous hisec'
    display: (item) -> item.jumps_to_continous_hisec

  filterName: 'Jumps to continous hisec'
