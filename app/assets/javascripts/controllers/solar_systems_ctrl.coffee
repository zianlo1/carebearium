CB.controller 'SolarSystemsCtrl', ($scope, $timeout, Storage, SolarSystems, FilterManager, $location) ->
  $scope.filters = Storage.get 'filters', []
  $scope.sort    = Storage.get 'sort', ['name', 'asc']

  $scope.solarSystems = []
  $scope.fields = {}
  $scope.loading = true
  $scope.availableFilters = {}
  $scope.linkHash = ''

  find = ->
    $scope.loading = true
    SolarSystems.find(filters: $scope.filters, sort: $scope.sort).then (results) ->
      $scope.loading = false
      $scope.fields = results.fields
      $scope.sort = results.sort
      $scope.solarSystems = results.data

      $scope.linkHash = CB.Helpers.objectToString { f: $scope.filters, s: $scope.sort }

      Storage.set 'filters', $scope.filters
      Storage.set 'sort', $scope.sort

  findTimeout = null
  findWithTimeout = ->
    $timeout.cancel findTimeout
    findTimeout = $timeout find, 500

  $scope.orderBy = (field, direction) ->
    $scope.sort = [field, if direction is 'asc' then 'desc' else 'asc']
    find()

  setAvailableFilters = ->
    availableFilters = {}

    for kind, klass of FilterManager
      instance = new klass
      if instance.multiple or not Lazy($scope.filters).map( (f) -> f.kind ).contains(kind)
        availableFilters[kind] = instance.filterName

    $scope.availableFilters = CB.Helpers.mapToSelectChoices availableFilters

  $scope.filterToAdd = null
  $scope.$watch 'filterToAdd', ->
    if $scope.filterToAdd
      $scope.filters.push { kind: $scope.filterToAdd }
    $scope.filterToAdd = null

  $scope.removeFilter = (filter) ->
    $scope.filters = Lazy($scope.filters).reject(filter).toArray()
  $scope.removeAllFilters = ->
    $scope.filters = []
    $scope.sort    = ['name', 'asc']

  $scope.$watch 'filters', setAvailableFilters, true
  $scope.$watch 'filters', findWithTimeout, true

  $scope.open = (solarSystem) ->
    $location.path "/solar_systems/#{solarSystem.id}"
