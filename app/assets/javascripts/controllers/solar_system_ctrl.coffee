CB.controller 'SolarSystemCtrl', ($scope, $http, solarSystem) ->
  $scope.solarSystem = solarSystem

  $scope.stationsCollapsed = true
  $scope.agentsCollapsed   = true
  $scope.planetsCollapsed  = true

  for agent in $scope.solarSystem.agents
    agent.divisionName    = CB.StaticData.AgentDivisions[agent.division]
    agent.corporationName = CB.StaticData.Corporations[agent.corporation_id]
