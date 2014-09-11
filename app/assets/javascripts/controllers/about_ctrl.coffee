CB.controller 'AboutCtrl', ($scope, Storage, FilterWithPreset) ->
  Storage.set 'seenAbout', true
  $scope.filterWithPreset = FilterWithPreset
