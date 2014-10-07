#= require ./slider

class CB.Filters.AgentCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.agents.length >= @options.min and item.agents.length <= @options.max

  mapFunction: (item) ->
    item.agentCount = item.agents.length
    item

  visibleField: ->
    field: 'agentCount'
    text: 'Agents'
    display: (item) -> item.agentCount

  filterName: 'Agent count'
