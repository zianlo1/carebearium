#= require ./base

class CB.Filters.Slider extends CB.Filters.Base
  scale: 1

  constructor: (@options) ->
    super(@options)

    @options.min = @limits.min * @scale if angular.isUndefined @options.min
    @options.max = @limits.max * @scale if angular.isUndefined @options.max

  translateFunction: (i) => i / @scale

  settings: =>
    min: @limits.min * @scale
    max: @limits.max * @scale
    name: @filterName
    translateFunction: @translateFunction

  templateName: 'slider'
