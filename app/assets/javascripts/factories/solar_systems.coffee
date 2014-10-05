CB.factory 'SolarSystems', ($q, $http) ->
  defer = $q.defer()

  $q.all([
    $http(url: '/api/solar_systems.json')
    $http(url: '/api/solar_systems_static.json')
  ]).then (results) ->
    defer.resolve Lazy(results[0].data).merge results[1].data

  defer.promise
