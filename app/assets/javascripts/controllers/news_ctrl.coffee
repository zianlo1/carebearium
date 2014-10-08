CB.controller 'NewsCtrl', ($scope, $routeParams, FilterWithPreset) ->
  if $routeParams.date
    document.getElementById("news-#{$routeParams.date}")?.scrollIntoView()

  $scope.filterWithPreset = FilterWithPreset
