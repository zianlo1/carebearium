#= require ./base

class CB.Filters.Security extends CB.Filters.Base
  scale: 10

  constructor: (@options) ->
    super(@options)

    @options.min ||= @constraints.min * @scale
    @options.max ||= @constraints.max * @scale

  filterFunction: (item) =>
    val = item.security * @scale
    val >= @options.min and val <= @options.max

  visibleFields: ->
    security:
      text: 'Security'
      display: (item) -> item.security.toFixed(1)

  filterName: 'Security'

  constraints:
    min: 0.5
    max: 1.0

  translateFunction: (i) => i / @scale

  settings: =>
    min: @constraints.min * @scale
    max: @constraints.max * @scale
    name: @filterName
    translateFunction: @translateFunction
