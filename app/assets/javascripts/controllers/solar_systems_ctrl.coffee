CB.controller 'SolarSystemsCtrl', ($scope, SolarSystems, Storage, FilterManager) ->
  $scope.filters = Storage.get 'filters', []
  $scope.sort    = Storage.get 'sort', ['name', 'asc']

  $scope.solarSystems = []
  $scope.fields = {}
  $scope.loading = true
  $scope.availableFilters = {}

  $scope.orderBy = (field, direction) ->
    $scope.sort = [field, if direction is 'asc' then 'desc' else 'asc']

  setAvailableFilters = ->
    $scope.availableFilters = {}

    for kind, klass of FilterManager
      instance = new klass
      if instance.multiple or not Lazy($scope.filters).map( (f) -> f.kind ).contains(kind)
        $scope.availableFilters[kind] = instance

  $scope.$watch 'filters', setAvailableFilters, true

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

  find = ->
    $scope.loading = true
    SolarSystems.find
      filters: $scope.filters
      sort: $scope.sort
      callback: (results) ->
        $scope.loading = false
        $scope.fields = results.fields
        $scope.solarSystems = results.data

  $scope.$watch 'filters', find, true
  $scope.$watch 'sort', find, true
