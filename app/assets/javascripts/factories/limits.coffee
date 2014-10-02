CB.factory 'Limits', ($q, $http) ->
  defer = $q.defer()

  $q.all([
    $http(url: '/api/limits.json')
    $http(url: '/api/limits_static.json')
  ]).then (results) ->
    defer.resolve _.merge results[0].data, results[1].data

  defer.promise
