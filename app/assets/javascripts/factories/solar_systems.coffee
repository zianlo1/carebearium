fieldsToAgent = (fields) ->
  { corporation_id: fields[0], level: fields[1], division: fields[2] }

fieldsToStation = (fields) ->
  station  = { name: fields[0] }
  services = CB.StaticData.StationOperations[fields[1]] || []

  station.refinery  = 32 in services
  station.cloning   = 512 in services
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
      system.invention           = fields[11]

      system.hourly_ships = fields[12]
      system.hourly_pods  = fields[13]
      system.hourly_npcs  = fields[14]
      system.hourly_jumps = fields[15]

      system.owner_id     = fields[16]
      system.owner        = CB.StaticData.SolarSystemOwnerNames[system.owner_id]
      system.player_owned = system.owner_id > 1000000

      system.x = fields[17]
      system.y = fields[18]
      system.z = fields[19]

      system.moon_count = fields[20]

      system.planets = []
      system.planet_count = 0
      for type_id, count of fields[21]
        system.planets.push { type_id: type_id, type: CB.StaticData.PlanetTypes[type_id], count: count }
        system.planet_count += count

      system.jumps_to_continous_hisec = fields[22]
      system.jumps_to_nearest_hisec   = fields[23]
      system.jumps_to_lowsec          = fields[24]
      system.jumps_to_nullsec         = fields[25]

      system.hisec_island = (system.jumps_to_nearest_hisec is 0) and (system.jumps_to_continous_hisec > 0)

      system.pirate_id   = CB.StaticData.RegionPirates[system.region_id]
      system.pirate_name = CB.StaticData.PirateNames[system.pirate_id]

      CB.StaticData.SolarSystems[id] = system

    dataLoaded.resolve()

  find = (options) ->
    result = $q.defer()

    dataLoaded.promise.then ->
      data = Lazy(CB.StaticData.SolarSystems).filter -> true

      visibleFields = [{ field: 'name', text: 'Name', display: (item) -> item.name }]

      for filterOptions in options.filters
        filter = new FilterManager[filterOptions.kind](filterOptions)

        filter.prepare()

        data = data.filter filter.reversibleFilterFunction

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

      result.resolve
        fields: visibleFields
        sort: options.sort
        data: data.toArray()

    result.promise

  findOne = (id) ->
    result = $q.defer()
    dataLoaded.promise.then ->
      result.resolve CB.StaticData.SolarSystems[id]
    result.promise

  {
    find: find
    findOne: findOne
  }
