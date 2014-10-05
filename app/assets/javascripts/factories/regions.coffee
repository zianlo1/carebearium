CB.factory 'Regions', ($q, $http) ->
  defer = $q.defer()

  $http(url: '/api/regions.json').success (data) -> defer.resolve data

  defer.promise
