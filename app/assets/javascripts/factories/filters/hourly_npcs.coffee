#= require ./slider

class CB.Filters.HourlyNpcs extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.hourly_npcs * @scale
    val >= @options.min and val <= @options.max

  visibleFields: ->
    hourly_npcs:
      text: 'NPC kills'
      display: (item) -> item.hourly_npcs.toFixed(5)

  filterName: 'Average hourly NPC kills'
