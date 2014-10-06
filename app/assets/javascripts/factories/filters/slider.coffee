#= require ./base

class CB.Filters.Slider extends CB.Filters.Base
  constructor: (@options) ->
    super(@options)

    @options.min ||= @limits.min * @scale
    @options.max ||= @limits.max * @scale

  translateFunction: (i) => i / @scale

  settings: =>
    min: @limits.min * @scale
    max: @limits.max * @scale
    name: @filterName
    translateFunction: @translateFunction
