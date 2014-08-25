CB.factory 'SolarSystemsCollection', (Restangular) ->
  Restangular.setRequestSuffix '.json'
  Restangular.all('solar_systems')
