CB.controller 'SolarSystemsCtrl', ($scope, SolarSystemsCollection, ngTableParams, constraints, $timeout) ->
  $scope.constraints = constraints.plain()

  $scope.securityTranslate = (val) -> parseFloat(val) / 10
  $scope.industryIndexTranslate = (val) -> parseFloat(val) / 1000

  $scope.fixSliders = ->
    # adjust every slider by a tiny margin then reset to old value to trigger re-draw on tab activation
    # in timeout, because angular is too smart to treat zero-sum change as change
    for own group, options of $scope.filter
      for own key, value of options
        if key in ['max', 'min']
          fn = (g, k, v) ->
            $timeout ->
              $scope.filter[g][k] = v
          options[key] = options[key] * 1.0001
          fn group, key, value

  $scope.loading = true

  $scope.resetFilters = ->
    $scope.filter = angular.copy $scope.constraints
    $scope.filter.region = {}
    $scope.filter.specific_agents = {}
    delete $scope.filter.agent_kind
    delete $scope.filter.agent_level
    delete $scope.filter.agent_corporation

  $scope.resetFilters()

  $scope.addAgentFilter = ->
    $scope.filter.specific_agents[Date.now()] = { kind: null, level: null, corporation: null }
  $scope.removeAgentFilter = (id) ->
    delete $scope.filter.specific_agents[id]

  $scope.columns = [
    { key: 'name',                      name: 'System name',          visible: true }
    { key: 'region_name',               name: 'Region name',          visible: true }
    { key: 'security',                  name: 'Security',             visible: true }
    { key: 'belt_count',                name: 'Asteroid belts',       visible: true }
    { key: 'stations_count',            name: 'Stations',             visible: false }
    { key: 'agents_count',              name: 'Agents',               visible: false }
    { key: 'manufacturing_index',       name: 'Manufacturing',        visible: true }
    { key: 'research_me_index',         name: 'ME research',          visible: false }
    { key: 'research_te_index',         name: 'TE research',          visible: false }
    { key: 'copying_index',             name: 'Copying',              visible: false }
    { key: 'reverse_engineering_index', name: 'Reverse engineering',  visible: false }
    { key: 'invention_index',           name: 'Invention',            visible: false }
  ]

  urlWas = null

  $scope.tableParams = new ngTableParams {
    count: 25
    filter: $scope.filter
    sorting:
      name: 'asc'
  }, {
    total: 0
    getData: ($defer, params) ->
      resolve = (data) ->
        $scope.loading = false
        $defer.resolve data

      # prevent calls to server due to $scope.fixSliders shenanigains
      if angular.equals urlWas, params.url()
        resolve params.data
      else
        urlWas = angular.copy params.url()
        $scope.loading = true
        SolarSystemsCollection.getList(params.url()).then resolve
  }
