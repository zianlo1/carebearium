CB.factory 'SolarSystems', ($q, $http, FilterManager) ->
  dataLoaded = $q.defer()

  $q.all([
    $http(url: '/api/solar_systems.json')
    $http(url: '/api/solar_systems_static.json')
  ]).then (results) ->
    Lazy(results[0].data).merge(results[1].data).each (system, id) ->
      system.id   = id
      system.name = CB.StaticData.SolarSystemNames[id]

      CB.StaticData.SolarSystems[id] = system

    dataLoaded.resolve()

  find = (options) ->
    dataLoaded.promise.then ->
      data = Lazy(CB.StaticData.SolarSystems).filter -> true

      visibleFields = [{ field: 'name', text: 'Name', display: (item) -> item.name }]

      for filterOptions in options.filters
        filter = new FilterManager[filterOptions.kind](filterOptions)

        filter.prepare()

        data = data.filter(filter.filterFunction).map(filter.mapFunction)

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
