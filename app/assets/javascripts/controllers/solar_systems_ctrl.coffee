CB.controller 'SolarSystemsCtrl', ($scope, $http, $timeout, filterConstraints) ->
  $scope.solarSystems = []
  $scope.filters      = {}
  $scope.order_by     = {}
  $scope.loading      = true
  $scope.fields       = []

  $scope.filterConstraints = filterConstraints
  $scope.filterToAdd = null
  $scope.$watch 'filterToAdd', ->
    if $scope.filterToAdd
      existingKeys   = _.keys($scope.filters)
      maxExistingKey = if _.any(existingKeys) then parseInt(_.max(existingKeys)) else 0
      $scope.filters[maxExistingKey + 1] = { kind: $scope.filterToAdd }
    $scope.filterToAdd = null

  fetchSolarSystems = ->
    $scope.loading = true
    $http(
      url: '/solar_systems.json',
      method: "GET",
      params:
        filters: $scope.filters
        order:   $scope.order_by
    ).success (solarSystems) ->
      $scope.fields       = solarSystems.fields
      $scope.solarSystems = solarSystems.data
      $scope.loading      = false

  fetchSolarSystemsTimeout = null
  fetchSolarSystemsWithTimeout = ->
    $timeout.cancel fetchSolarSystemsTimeout
    fetchSolarSystemsTimeout = $timeout fetchSolarSystems, 1000

  $scope.$watch 'filters', fetchSolarSystemsWithTimeout, true

  fetchSolarSystems()
