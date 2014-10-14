#= require ./base

class CB.Filters.DistanceJumps extends CB.Filters.Base
  constructor: (@options) ->
    super(@options)

    @options.min = 0 if angular.isUndefined @options.min
    @options.max = 10 if angular.isUndefined @options.max
    @options.security = '0.5' if angular.isUndefined @options.security

  securityOptions:
    '0.5': 'hisec'
    '0.1': 'hisec & lowsec'
    '-1':  'by any space'

  prepare: =>
    @reachableSystems = {}

    if @options.system
      minSecurity = parseFloat(@options.security)

      @reachableSystems[@options.system] = 0

      if @options.max > 0
        visitNow  = []
        visitNext = angular.copy CB.StaticData.SolarSystems[@options.system].jumps
        depth     = 1

        while visitNext.length > 0 and depth <= @options.max
          visitNow  = angular.copy visitNext
          visitNext = []

          Lazy(visitNow)
            .uniq()
            .filter( (id) => angular.isUndefined(@reachableSystems[id]) and not angular.isUndefined(CB.StaticData.SolarSystems[id]) )
            .map( (id) -> CB.StaticData.SolarSystems[id] )
            .filter( (system) -> system.security >= minSecurity )
            .each (system) =>
              @reachableSystems[system.id] = depth
              visitNext.push next for next in system.jumps

          depth += 1

    @fieldName = "distance_jumps_#{@options.system || '_'}_#{@options.security || '_'}"
    @columName = "Jumps to #{CB.StaticData.SolarSystemNames[@options.system]} by #{@securityOptions[@options.security]}"

  filterFunction: (item) =>
    if @options.system
      @reachableSystems[item.id] >= @options.min
    else
      true

  mapFunction: (item) =>
    if @options.system
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
    securityOptions: CB.Helpers.mapToSelectChoices @securityOptions

  templateName: 'distance_jumps'
