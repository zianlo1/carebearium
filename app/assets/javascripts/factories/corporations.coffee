CB.factory 'Corporations', ($q, $http) ->
  defer = $q.defer()

  $http(url: '/api/corporations.json').success (data) -> defer.resolve data

  defer.promise
