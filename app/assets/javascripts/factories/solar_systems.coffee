CB.factory 'SolarSystems', ($q, $http, Storage, FilterManager) ->
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
    Storage.set 'filters', options.filters
    Storage.set 'sort', options.sort

    sortField     = options.sort[0] || 'name'
    sortDirection = options.sort[1] || 'asc'

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

      data = data.sortBy (item) -> item[sortField]
      data = data.reverse() unless sortDirection is 'asc'

      sortedField = Lazy(visibleFields).findWhere { field: sortField }
      if sortedField
        sortedField.sorted = sortDirection

      data = data.first(50)

      options.callback
        fields: visibleFields
        data: data.toArray()

  {
    find: find
    getFilters: -> Storage.get 'filters', []
    getSort: -> Storage.get 'sort', ['name', 'asc']
  }
