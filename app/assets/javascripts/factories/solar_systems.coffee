CB.factory 'SolarSystems', ($q, $http) ->
  rawData = {}
  rawDataLoaded = $q.defer()

  $q.all([
    $http(url: '/api/solar_systems.json')
    $http(url: '/api/solar_systems_static.json')
  ]).then (results) ->
    rawData = Lazy(results[0].data).merge results[1].data
    rawDataLoaded.resolve()

  find = (options) ->
    sortField     = options.sort[0] || 'name'
    sortDirection = options.sort[1] || 'asc'
    rawDataLoaded.promise.then ->
      data = rawData

      visibleFields =
        name: { text: 'Name', sorted: false }

      data = data.sortBy (parts) -> parts[1][sortField]
      data = data.reverse() unless sortDirection is 'asc'

      if visibleFields[sortField]
        visibleFields[sortField].sorted = sortDirection

      data = data.first(50)

      data = data.map (parts) ->
        parts[1].id = parts[0]
        parts[1]

      options.callback
        fields: visibleFields
        data: data.toArray()

  { find: find }
