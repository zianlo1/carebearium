fieldsToAgent = (fields) ->
  { corporation_id: fields[0], level: fields[1], division: fields[2] }

fieldsToStation = (fields) ->
  station  = { name: fields[0] }
  services = CB.StaticData.StationOperations[fields[1]] || []

  station.refinery  = 32 in services
  station.repair    = 4096 in services
  station.factory   = 8192 in services
  station.lab       = 16384 in services
  station.insurance = 1048576 in services

  station

nullsecRegex = /^[A-Z0-9]{1,5}-[A-Z0-9]{1,5}$/

CB.factory 'SolarSystems', ($q, $http, FilterManager) ->
  dataLoaded = $q.defer()

  $http(url: '/api/solar_systems.json').success (data) ->
    for id, fields of data
      system = { id: id, name: CB.StaticData.SolarSystemNames[id] }
      system.region_id  = fields[0]
      system.region     = CB.StaticData.Regions[system.region_id]
      system.security   = fields[1]
      system.belt_count = fields[2]
      system.ice        = fields[3]

      system.stations = []
      for stationFields in fields[4]
        system.stations.push fieldsToStation stationFields

      system.agents = []
      for agentFields in fields[5]
        system.agents.push fieldsToAgent agentFields

      system.jumps = fields[6]

      system.manufacturing       = fields[7]
      system.research_te         = fields[8]
      system.research_me         = fields[9]
      system.copying             = fields[10]
      system.reverse_engineering = fields[11]
      system.invention           = fields[12]

      system.hourly_ships = fields[13]
      system.hourly_pods  = fields[14]
      system.hourly_npcs  = fields[15]
      system.hourly_jumps = fields[16]

      system.owner_id = fields[17]
      system.owner    = CB.StaticData.SolarSystemOwnerNames[system.owner_id]

      system.x = fields[18]
      system.y = fields[19]
      system.z = fields[20]

      CB.StaticData.SolarSystems[id] = system

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

      data = data.sortBy (item) ->
        if options.sort[0] is 'name'
          [ item.name.match(nullsecRegex), item.name ]
        else
          item[options.sort[0]]
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
