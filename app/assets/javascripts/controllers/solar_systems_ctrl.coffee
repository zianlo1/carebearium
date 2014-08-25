CB.controller 'SolarSystemsCtrl', ($scope, SolarSystemsCollection, ngTableParams) ->
  $scope.solarSystems = []

  $scope.securityTranslate = (val) -> parseFloat(val) / 100

  $scope.filter =
    security:
      min: 40
      max: 100
    belts:
      min: 0
      max: 50
    stations:
      min: 0
      max: 22
    agents:
      min: 0
      max: 38

  $scope.tableParams = new ngTableParams {
    count: 100
    filter: $scope.filter
    sorting:
      name: 'asc'
  }, {
    total: 0
    getData: ($defer, params) ->
      SolarSystemsCollection.getList(params.url()).then (data) ->
        $defer.resolve data
  }
