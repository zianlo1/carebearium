#= require ./base

class CB.Filters.Slider extends CB.Filters.Base
  offset: 0

  constructor: (@options) ->
    super(@options)

    @options.min ||= @limits.min * @scale + @offset
    @options.max ||= @limits.max * @scale + @offset

  translateFunction: (i) => (i - @offset) / @scale

  settings: =>
    min: @limits.min * @scale + @offset
    max: @limits.max * @scale + @offset
    name: @filterName
    translateFunction: @translateFunction

  templateName: 'slider'
