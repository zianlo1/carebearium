CB.controller 'SolarSystemsCtrl', ($scope, $timeout, SolarSystems, FilterManager) ->
  $scope.filters = SolarSystems.getFilters()
  $scope.sort    = SolarSystems.getSort()

  $scope.solarSystems = []
  $scope.fields = {}
  $scope.loading = true
  $scope.availableFilters = {}

  find = ->
    $scope.loading = true
    SolarSystems.find
      filters: $scope.filters
      sort: $scope.sort
      callback: (results) ->
        $scope.loading = false
        $scope.fields = results.fields
        $scope.solarSystems = results.data

  findTimeout = null
  findWithTimeout = ->
    $timeout.cancel findTimeout
    findTimeout = $timeout find, 500

  $scope.orderBy = (field, direction) ->
    $scope.sort = [field, if direction is 'asc' then 'desc' else 'asc']
    find()

  setAvailableFilters = ->
    $scope.availableFilters = {}

    for kind, klass of FilterManager
      instance = new klass
      if instance.multiple or not Lazy($scope.filters).map( (f) -> f.kind ).contains(kind)
        $scope.availableFilters[kind] = instance

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
