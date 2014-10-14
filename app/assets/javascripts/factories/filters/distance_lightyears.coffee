#= require ./base

class CB.Filters.DistanceLightyears extends CB.Filters.Base
  scale: 100

  constructor: (@options) ->
    super(@options)

    @options.min = 0 if angular.isUndefined @options.min
    @options.max = 100 if angular.isUndefined @options.max

  prepare: =>
    @minSquared = Math.pow(@options.min / @scale, 2)
    @maxSquared = Math.pow(@options.max / @scale, 2)
    @systemCoordinates = CB.StaticData.SolarSystems[@options.system]

    @fieldName = "distance_lightyears_#{@options.system || '_'}"
    @columName = "LY to #{CB.StaticData.SolarSystemNames[@options.system]}"

  distanceBetweenSquared: (a, b) ->
    Math.pow(a.x-b.x, 2) + Math.pow(a.y-b.y, 2) + Math.pow(a.z-b.z, 2)

  filterFunction: (item) =>
    if @options.system
      distanceSquared = @distanceBetweenSquared @systemCoordinates, item
      distanceSquared >= @minSquared and distanceSquared <= @maxSquared
    else
      true

  mapFunction: (item) =>
    if @options.system
      item[@fieldName] = Math.sqrt(@distanceBetweenSquared @systemCoordinates, item).toFixed(2)
    item

  translateFunction: (i) => i / @scale

  visibleField: =>
    if @options.system
      field: @fieldName
      text: @columName
      display: (item) => item[@fieldName]

  multiple: true

  filterName: 'Within X lightyears of'

  settings: =>
    min: 0
    max: 10 * @scale
    name: @filterName
    translateFunction: @translateFunction
    systems: CB.Helpers.mapToSelectChoices CB.StaticData.SolarSystemNames
    systemName: (id) -> CB.StaticData.SolarSystemNames[id]

  templateName: 'distance_lightyears'
