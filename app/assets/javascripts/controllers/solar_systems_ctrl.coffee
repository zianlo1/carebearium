CB.controller 'SolarSystemsCtrl', ($scope, SolarSystemsCollection, ngTableParams, constraints) ->
  $scope.solarSystems = []

  $scope.constraints = constraints.plain()

  $scope.securityTranslate = (val) -> parseFloat(val) / 100
  $scope.industryIndexTranslate = (val) -> parseFloat(val) / 1000

  $scope.loading = true

  $scope.filter = angular.copy $scope.constraints

  $scope.tableParams = new ngTableParams {
    count: 25
    filter: $scope.filter
    sorting:
      name: 'asc'
  }, {
    total: 0
    getData: ($defer, params) ->
      $scope.loading = true
      SolarSystemsCollection.getList(params.url()).then (data) ->
        $scope.loading = false
        $defer.resolve data
  }
