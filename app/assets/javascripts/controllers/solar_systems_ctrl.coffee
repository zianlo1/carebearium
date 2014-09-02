CB.controller 'SolarSystemsCtrl', ($scope, $http, $timeout, filterConstraints) ->
  $scope.solarSystems = []
  $scope.filters      = {}
  $scope.order_by     = {}
  $scope.loading      = true
  $scope.fields       = [
    { field: 'name',        title: 'System name' }
    { field: 'region_name', title: 'Region name' }
    { field: 'security',    title: 'Security',   transform: (value) -> parseFloat(value).toFixed(1) }
  ]

  $scope.filterConstraints = filterConstraints
  $scope.filterToAdd = null
  $scope.$watch 'filterToAdd', ->
    if $scope.filterToAdd
      existingKeys   = _.keys($scope.filters)
      maxExistingKey = if _.any(existingKeys) then parseInt(_.max(existingKeys)) else 0
      $scope.filters[maxExistingKey + 1] = { kind: $scope.filterToAdd }
    $scope.filterToAdd = null

  fetchSolarSystems = ->
    $scope.loading = true
    $http(
      url: '/solar_systems.json',
      method: "GET",
      params:
        filters: $scope.filters
        order:   $scope.order_by
    ).success (solarSystems) ->
      $scope.solarSystems = solarSystems
      $scope.loading      = false

  fetchSolarSystemsTimeout = null
  fetchSolarSystemsWithTimeout = ->
    $timeout.cancel fetchSolarSystemsTimeout
    fetchSolarSystemsTimeout = $timeout fetchSolarSystems, 1000

  $scope.$watch 'filters', fetchSolarSystemsWithTimeout, true

  fetchSolarSystems()

# CB.controller 'SolarSystemsCtrl', ($scope, SolarSystemsCollection, ngTableParams, constraints, $timeout, CBAutocomplete) ->
#   $scope.constraints = constraints.plain()
#   $scope.systemNames = []
#
#   $scope.securityTranslate = (val) -> parseFloat(val) / 10
#   $scope.industryIndexTranslate = (val) -> parseFloat(val) / 1000
#
#   $scope.autocompleteSolarSystems = CBAutocomplete 'solar_systems/names', (results) -> $scope.systemNames = results
#
#   $scope.columns = [
#     { key: 'name',                      name: 'System name',          visible: true,  tab: 'Location' }
#     { key: 'region_name',               name: 'Region name',          visible: true,  tab: 'Location' }
#     { key: 'security',                  name: 'Security',             visible: true,  tab: 'Location' }
#     { key: 'belts_count',               name: 'Asteroid belts',       visible: true,  tab: 'Celestials' }
#     { key: 'stations_count',            name: 'Stations',             visible: false, tab: 'Celestials' }
#     { key: 'agents_count',              name: 'Total agents',         visible: false, tab: 'Agents' }
#     { key: 'manufacturing_index',       name: 'Manufacturing',        visible: true,  tab: 'Industry indices' }
#     { key: 'research_me_index',         name: 'ME research',          visible: false, tab: 'Industry indices' }
#     { key: 'research_te_index',         name: 'TE research',          visible: false, tab: 'Industry indices' }
#     { key: 'copying_index',             name: 'Copying',              visible: false, tab: 'Industry indices' }
#     { key: 'reverse_engineering_index', name: 'Reverse engineering',  visible: false, tab: 'Industry indices' }
#     { key: 'invention_index',           name: 'Invention',            visible: false, tab: 'Industry indices' }
#   ]
