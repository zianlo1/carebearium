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
        visitNow  = []
        visitNext = angular.copy CB.StaticData.SolarSystems[@options.system].jumps
        depth     = 1

        while visitNext.length > 0 and depth <= @options.distance
          visitNow  = angular.copy visitNext
          visitNext = []

          for id in visitNow
            @reachableSystems[id] = depth
            for next in CB.StaticData.SolarSystems[id].jumps
              if typeof @reachableSystems[next] == 'undefined'
                visitNext.push next

          depth += 1

    @fieldName = "distance_jumps_#{@options.system || '_'}"
    @columName = "Jumps to #{CB.StaticData.SolarSystemNames[@options.system]}"

  filterFunction: (item) =>
    if @options.system
      typeof @reachableSystems[item.id] != 'undefined'
    else
      true

  mapFunction: (item) =>
    item[@fieldName] = @reachableSystems[item.id]
    item

  visibleField: =>
    if @options.system
      field: @fieldName
      text: @columName
      display: (item) => item[@fieldName]

  multiple: true

  filterName: 'Within X jumps of'

  settings: =>
    min: 0
    max: 50
    name: @filterName
    systems: CB.Helpers.mapToSelectChoices CB.StaticData.SolarSystemNames
    systemName: (id) -> CB.StaticData.SolarSystemNames[id]

  templateName: 'distance_jumps'
