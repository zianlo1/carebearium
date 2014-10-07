#= require ./slider

class CB.Filters.StationCount extends CB.Filters.Slider
  scale: 1

  filterFunction: (item) =>
    item.stations.length >= @options.min and item.stations.length <= @options.max

  mapFunction: (item) ->
    item.stationCount = item.stations.length
    item

  visibleField: ->
    field: 'stationCount'
    text: 'Stations'
    display: (item) -> item.stationCount

  filterName: 'Station count'
