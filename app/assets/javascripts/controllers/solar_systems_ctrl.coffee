CB.controller 'SolarSystemsCtrl', ($scope, SolarSystemsCollection, ngTableParams, constraints, $timeout) ->
  $scope.constraints = constraints.plain()

  $scope.securityTranslate = (val) -> parseFloat(val) / 100
  $scope.industryIndexTranslate = (val) -> parseFloat(val) / 1000

  $scope.fixSliders = ->
    # adjust every slider by a tiny margin then reset to old value to trigger re-draw on tab activation
    # in timeout, because angular is too smart to treat zero-sum change as change
    for own group, options of $scope.filter
      for own key, value of options
        if key in ['max', 'min']
          fn = (g, k, v) ->
            $timeout ->
              $scope.filter[g][k] = v
          options[key] = options[key] * 1.0001
          fn group, key, value

  $scope.loading = true

  $scope.filter = angular.copy $scope.constraints

  urlWas = null

  $scope.tableParams = new ngTableParams {
    count: 25
    filter: $scope.filter
    sorting:
      name: 'asc'
  }, {
    total: 0
    getData: ($defer, params) ->
      resolve = (data) ->
        $scope.loading = false
        $defer.resolve data

      # prevent calls to server due to $scope.fixSliders shenanigains
      if angular.equals urlWas, params.url()
        resolve params.data
      else
        urlWas = angular.copy params.url()
        $scope.loading = true
        SolarSystemsCollection.getList(params.url()).then resolve
  }
