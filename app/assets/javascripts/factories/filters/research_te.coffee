#= require ./slider

class CB.Filters.ResearchTE extends CB.Filters.Slider
  scale: 100000

  filterFunction: (item) =>
    val = item.research_te * @scale
    val >= @options.min and val <= @options.max

  visibleFields: ->
    research_te:
      text: 'Research TE'
      display: (item) -> item.research_te.toFixed(5)

  filterName: 'Research TE index'
