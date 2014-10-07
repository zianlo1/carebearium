CB.factory 'SolarSystems', ($q, $http, FilterManager) ->
  rawData = {}
  rawDataLoaded = $q.defer()

  $q.all([
    $http(url: '/api/solar_systems.json')
    $http(url: '/api/solar_systems_static.json')
  ]).then (results) ->
    rawData = Lazy(results[0].data).merge(results[1].data)
    rawDataLoaded.resolve()

  find = (options) ->
    sortField     = options.sort[0] || 'name'
    sortDirection = options.sort[1] || 'asc'
    rawDataLoaded.promise.then ->
      data = rawData.filter -> true

      visibleFields =
        name: { text: 'Name', display: (item) -> item.name }

      for filterOptions in options.filters
        filter = new FilterManager[filterOptions.kind](filterOptions)

        filter.prepare()

        data = data.filter(filter.filterFunction).map(filter.mapFunction)

        visibleFields[key] = value for key, value of filter.visibleFields()

      data = data.sortBy (item) -> item[sortField]
      data = data.reverse() unless sortDirection is 'asc'
      if visibleFields[sortField]
        visibleFields[sortField].sorted = sortDirection

      data = data.first(50)

      options.callback
        fields: visibleFields
        data: data.toArray()

  { find: find }
