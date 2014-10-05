CB.controller 'SolarSystemsCtrl', ($scope, SolarSystems, Storage) ->
  filter = Storage.get 'filter', {}
  order  = Storage.get 'order', { name: 'asc' }
  $scope.solarSystems = []

  SolarSystems.find
    filter: filter
    order: order
    callback: (solarSystems) ->
      $scope.solarSystems = solarSystems
