#= require ./slider

class CB.Filters.HourlyPods extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.hourly_pods * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'hourly_pods'
    text: 'Pod kills / h'
    display: (item) -> item.hourly_pods.toFixed(5)

  filterName: 'Average hourly pod kills'
