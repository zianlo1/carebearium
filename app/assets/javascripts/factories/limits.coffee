CB.factory 'Limits', ($q, $http) ->
  defer = $q.defer()

  $q.all([
    $http(url: '/api/limits.json')
    $http(url: '/api/limits_static.json')
  ]).then (results) ->
    defer.resolve Lazy(results[0].data).merge results[1].data

  defer.promise
