CB.controller 'SolarSystemsCtrl', ($scope, SolarSystems, Storage) ->
  filters = Storage.get 'filters', []
  sort    = Storage.get 'sort', ['name', 'asc']

  $scope.solarSystems = []
  $scope.fields = {}
  $scope.loading = true

  $scope.orderBy = (field, direction) ->
    sort = [field, if direction is 'asc' then 'desc' else 'asc']
    find()

  find = ->
    $scope.loading = true
    SolarSystems.find
      filters: filters
      sort: sort
      callback: (results) ->
        $scope.loading = false
        $scope.fields = results.fields
        $scope.solarSystems = results.data

  find()
