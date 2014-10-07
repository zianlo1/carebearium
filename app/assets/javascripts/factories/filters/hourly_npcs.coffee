#= require ./slider

class CB.Filters.HourlyNpcs extends CB.Filters.Slider
  scale: 10

  filterFunction: (item) =>
    val = item.hourly_npcs * @scale
    val >= @options.min and val <= @options.max

  visibleField: ->
    field: 'hourly_npcs'
    text: 'NPC kills / h'
    display: (item) -> item.hourly_npcs.toFixed(1)

  filterName: 'Average hourly NPC kills'
