CB.factory 'SolarSystemFinder', ($http, Storage) ->
  fetch = (filter, order, callback) ->
    Storage.set 'filter', filter
    Storage.set 'order', order
    $http(
      url: '/solar_systems.json',
      method: "GET",
      params:
        filters: filter
        order: order
    ).success callback

  solarSystemFinder =
    fetch: fetch
    filter: -> Storage.get 'filter', {}
    order:  -> Storage.get 'order', { name: 'asc' }
