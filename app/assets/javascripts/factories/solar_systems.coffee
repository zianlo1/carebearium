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
    rawDataLoaded.promise.then ->
      data = rawData

      for field, direction of options.order
        data = data.sortBy (parts) ->
          parts[1][field]

      data = data.first(50)

      data = data.map (parts) ->
        id     = parts[0]
        fields = parts[1]

        fields.id = id
        fields

      options.callback data.toArray()

  { find: find }
