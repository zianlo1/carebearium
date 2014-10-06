#= require ./base

class CB.Filters.Security extends CB.Filters.Base
  scale: 10

  constructor: (@options) ->
    super(@options)

    @options.min ||= @limits.min * @scale
    @options.max ||= @limits.max * @scale

  filterFunction: (item) =>
    val = item.security * @scale
    val >= @options.min and val <= @options.max

  visibleFields: ->
    security:
      text: 'Security'
      display: (item) -> item.security.toFixed(1)

  filterName: 'Security'

  translateFunction: (i) => i / @scale

  settings: =>
    min: @limits.min * @scale
    max: @limits.max * @scale
    name: @filterName
    translateFunction: @translateFunction
