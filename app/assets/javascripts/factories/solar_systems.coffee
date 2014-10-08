CB.factory 'SolarSystems', ($q, $http, FilterManager) ->
  dataLoaded = $q.defer()

  $q.all([
    $http(url: '/api/solar_systems.json')
    $http(url: '/api/solar_systems_static.json')
  ]).then (results) ->
    dynamicData = results[0].data
    staticData  = results[1].data

    for id, fields of staticData
      system = { id: id, name: CB.StaticData.SolarSystemNames[id] }
      system.regionID  = fields[0]
      system.region    = CB.StaticData.Regions[system.regionID]
      system.security  = fields[1]
      system.beltCount = fields[2]
      system.ice       = fields[3] is 1

      system.stations = []
      for stationFields in fields[4]
        station = {}
        station.name      = stationFields[0]
        station.refinery  = stationFields[1] is 1
        station.repair    = stationFields[2] is 1
        station.factory   = stationFields[3] is 1
        station.lab       = stationFields[4] is 1
        station.insurance = stationFields[5] is 1

        system.stations.push station

      system.agents = []
      for agentFields in fields[5]
        agent = {}
        agent.corporationID = agentFields[0]
        agent.level         = agentFields[1]
        agent.division      = agentFields[2]

        system.agents.push agent

      system.jumps = fields[6]

      CB.StaticData.SolarSystems[id] = system

    for id, fields of dynamicData
      CB.StaticData.SolarSystems[id] ||= { id: id, name: CB.StaticData.SolarSystemNames[id] }
      CB.StaticData.SolarSystems[id].manufacturing       = fields[0]
      CB.StaticData.SolarSystems[id].research_te         = fields[1]
      CB.StaticData.SolarSystems[id].research_me         = fields[2]
      CB.StaticData.SolarSystems[id].copying             = fields[3]
      CB.StaticData.SolarSystems[id].reverse_engineering = fields[4]
      CB.StaticData.SolarSystems[id].invention           = fields[5]
      CB.StaticData.SolarSystems[id].hourly_ships        = fields[6]
      CB.StaticData.SolarSystems[id].hourly_pods         = fields[7]
      CB.StaticData.SolarSystems[id].hourly_npcs         = fields[8]

    dataLoaded.resolve()

  find = (options) ->
    dataLoaded.promise.then ->
      data = Lazy(CB.StaticData.SolarSystems).filter -> true

      visibleFields = [{ field: 'name', text: 'Name', display: (item) -> item.name }]

      for filterOptions in options.filters
        filter = new FilterManager[filterOptions.kind](filterOptions)

        filter.prepare()

        data = data.filter filter.filterFunction

        if filter.mapFunction
          data = data.map filter.mapFunction

        additionalVisibleField = filter.visibleField()
        if additionalVisibleField
          visibleFields.push additionalVisibleField

      unless Lazy(visibleFields).findWhere { field: options.sort[0] }
        options.sort = ['name', 'asc']

      data = data.sortBy (item) -> item[options.sort[0]]
      data = data.reverse() unless options.sort[1] is 'asc'

      sortedField = Lazy(visibleFields).findWhere { field: options.sort[0] }
      if sortedField
        sortedField.sorted = options.sort[1]

      data = data.first(50)

      options.callback
        fields: visibleFields
        sort: options.sort
        data: data.toArray()

  { find: find }