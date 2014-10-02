# CB.factory 'SolarSystemFinder', ($http, $q, Storage) ->
#   solarSystems = {}
#
#   $http(url: '/api/solar_systems_static.json', method: 'GET').success (data) ->
#     solarSystems = data
#
#   fetch = (filter, order, callback) ->
#     Storage.set 'filter', filter
#     Storage.set 'order', order
#
#     $http(
#       url: '/solar_systems.json',
#       method: "GET",
#       params:
#         filters: filter
#         order: order
#     ).success callback
#
#   solarSystemFinder =
#     fetch: fetch
#     filter: -> Storage.get 'filter', {}
#     order:  -> Storage.get 'order', { name: 'asc' }
