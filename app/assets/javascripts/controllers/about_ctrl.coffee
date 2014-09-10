CB.controller 'AboutCtrl', ($scope, storage, $location) ->
  storage.set 'seenAbout', true

  $scope.filterWithPreset = (filter, order) ->
    storage.set 'filters', filter
    storage.set 'order', order
    $location.path '/solar_systems'
