CB.controller 'SolarSystemModalCtrl', ($scope, $http, solarSystem) ->
  $scope.solarSystem = solarSystem

  $scope.stationsCollapsed = true
  $scope.agentsCollapsed   = true

  $http(
    url: "/solar_systems/#{solarSystem._id}.json",
    method: "GET"
  ).success (data) ->
    $scope.solarSystem = data
