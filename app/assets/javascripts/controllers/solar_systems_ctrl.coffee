CB.controller 'SolarSystemsCtrl', ($scope, $http, $timeout, filterConstraints, Storage, $modal) ->
  $scope.solarSystems = []
  $scope.loading      = true
  $scope.fields       = []
  $scope.filters      = Storage.get 'filters', {}
  order               = Storage.get 'order', { name: 'asc' }

  fetchSolarSystems = ->
    $scope.loading = true
    $http(
      url: '/solar_systems.json',
      method: "GET",
      params:
        filters: $scope.filters
        order: order
    ).success (solarSystems) ->
      Storage.set 'filters', $scope.filters
      Storage.set 'order', order

      $scope.fields       = solarSystems.fields
      $scope.solarSystems = solarSystems.data
      $scope.loading      = false

  fetchSolarSystemsTimeout = null
  fetchSolarSystemsWithTimeout = ->
    $timeout.cancel fetchSolarSystemsTimeout
    fetchSolarSystemsTimeout = $timeout fetchSolarSystems, 1000

  $scope.filterConstraints = {}
  setAvailableFilters = ->
    availableConstraints = {}

    for kind, constraint of filterConstraints
      if constraint.multi or not _.any($scope.filters, (filter) -> filter.kind is kind)
        availableConstraints[kind] = constraint

    $scope.filterConstraints = availableConstraints

  $scope.$watch 'filters', setAvailableFilters, true

  $scope.filterToAdd = null
  $scope.$watch 'filterToAdd', ->
    if $scope.filterToAdd
      existingKeys   = _.keys($scope.filters)
      maxExistingKey = if _.any(existingKeys) then parseInt(_.max(existingKeys)) else 0
      $scope.filters[maxExistingKey + 1] = { kind: $scope.filterToAdd }
    $scope.filterToAdd = null
  $scope.removeAllFilters = ->
    $scope.filters = {}
    order          = { name: 'asc' }
  $scope.removeFilter = (filter) ->
    delete $scope.filters[_.findKey $scope.filters, filter]

  $scope.$watch 'filters', fetchSolarSystemsWithTimeout, true

  $scope.orderableBy = (field) ->
    field.orderable and not _.has(order, field.field)
  $scope.orderedBy = (field, direction) ->
    _.has(order, field.field) and order[field.field] is direction
  $scope.orderBy = (field) ->
    if _.has(order, field.field)
      order[field.field] = if order[field.field] is 'asc' then 'desc' else 'asc'
    else
      order = {}
      order[field.field] = 'asc'
    fetchSolarSystems()

  $scope.showInModal = (solarSystem) ->
    modalInstance = $modal.open
      template: JST['solar_system_modal']()
      controller: 'SolarSystemModalCtrl'
      size: 'lg'
      resolve:
        solarSystem: -> solarSystem
