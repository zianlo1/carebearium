#= require ./base

class CB.Filters.DistanceLightyears extends CB.Filters.Base
  scale: 100

  constructor: (@options) ->
    super(@options)

    @options.distance = 0 if angular.isUndefined @options.distance

  prepare: =>
    @distanceSquared = Math.pow(@options.distance / @scale, 2)
    @systemCoordinates = CB.StaticData.SolarSystems[@options.system]

    @fieldName = "distance_lightyears_#{@options.system || '_'}"
    @columName = "LY to #{CB.StaticData.SolarSystemNames[@options.system]}"

  distanceBetweenSquared: (a, b) ->
    Math.pow(a.x-b.x, 2) + Math.pow(a.y-b.y, 2) + Math.pow(a.z-b.z, 2)

  filterFunction: (item) =>
    if @options.system
      @distanceSquared >= @distanceBetweenSquared @systemCoordinates, item
    else
      true

  mapFunction: (item) =>
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
