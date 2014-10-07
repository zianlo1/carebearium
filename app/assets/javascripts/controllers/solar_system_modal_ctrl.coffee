CB.controller 'SolarSystemModalCtrl', ($scope, $http, solarSystem) ->
  $scope.solarSystem = solarSystem

  $scope.stationsCollapsed = true
  $scope.agentsCollapsed   = true

  for agent in $scope.solarSystem.agents
    agent.divisionName    = CB.StaticData.AgentDivisions[agent.division]
    agent.corporationName = CB.StaticData.Corporations[agent.corporationID]
