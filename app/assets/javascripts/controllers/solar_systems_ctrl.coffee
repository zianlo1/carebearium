CB.controller 'SolarSystemsCtrl', ($scope, $http, $timeout, filterConstraints) ->
  $scope.solarSystems = []
  $scope.filters      = {}
  $scope.loading      = true
  $scope.fields       = []

  fetchSolarSystems = ->
    order = {}
    order[orderByFiled] = orderByDirection

    $scope.loading = true
    $http(
      url: '/solar_systems.json',
      method: "GET",
      params:
        filters: $scope.filters
        order: order
    ).success (solarSystems) ->
      $scope.fields       = solarSystems.fields
      $scope.solarSystems = solarSystems.data
      $scope.loading      = false

  fetchSolarSystemsTimeout = null
  fetchSolarSystemsWithTimeout = ->
    $timeout.cancel fetchSolarSystemsTimeout
    fetchSolarSystemsTimeout = $timeout fetchSolarSystems, 1000

  $scope.filterConstraints = filterConstraints
  $scope.filterToAdd = null
  $scope.$watch 'filterToAdd', ->
    if $scope.filterToAdd
      existingKeys   = _.keys($scope.filters)
      maxExistingKey = if _.any(existingKeys) then parseInt(_.max(existingKeys)) else 0
      $scope.filters[maxExistingKey + 1] = { kind: $scope.filterToAdd }
    $scope.filterToAdd = null

  $scope.$watch 'filters', fetchSolarSystemsWithTimeout, true

  orderByFiled     = 'name'
  orderByDirection = 'asc'
  $scope.orderableBy = (field) ->
    field.orderable and not (field.field is orderByFiled)
  $scope.orderedBy = (field, direction) ->
    field.field is orderByFiled and direction is orderByDirection
  $scope.orderBy = (field) ->
    if field.field is orderByFiled
      orderByDirection = if orderByDirection is 'asc' then 'desc' else 'asc'
    else
      orderByFiled = field.field
      orderByDirection = 'asc'
    fetchSolarSystems()
