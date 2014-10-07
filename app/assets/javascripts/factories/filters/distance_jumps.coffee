#= require ./base

class CB.Filters.DistanceJumps extends CB.Filters.Base
  constructor: (@options) ->
    super(@options)
    @options.distance ||= 0

  prepare: =>
    @reachableSystems = {}

    if @options.system
      @reachableSystems[@options.system] = 0

    if @options.distance > 0
      console.log 'append reachables'

    @fieldName = "distance_jumps_#{@options.system || '_'}_#{@options.distance || '_'}"
    @columName = "Jumps to #{CB.StaticData.SolarSystemNames[@options.system]}"

  filterFunction: (item) =>
    if @options.system
      @reachableSystems[item.id]?
    else
      true

  mapFunction: (item) =>
    item[@fieldName] = @reachableSystems[item.id]
    item

  visibleFields: =>
    fields = {}

    if @options.system
      fields[@fieldName] =
        text: @columName
        display: (item) => item[@fieldName]

    fields

  multiple: true

  filterName: 'Within X jumps of'

  settings: =>
    min: 0
    max: 20
    name: @filterName
    prompt: 'Select a system...'
    systems: CB.StaticData.SolarSystemNames

  templateName: 'distance'
