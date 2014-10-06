#= require ./slider

class CB.Filters.ResearchME extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.research_me * @scale
    val >= @options.min and val <= @options.max

  visibleFields: ->
    manufacturing:
      text: 'Research ME'
      display: (item) -> item.research_me.toFixed(5)

  filterName: 'Research ME index'
