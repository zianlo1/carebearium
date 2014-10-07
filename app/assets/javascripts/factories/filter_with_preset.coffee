CB.factory 'FilterWithPreset', (Storage, $location) ->
  (filters, sort) ->
    Storage.set 'filters', filters
    Storage.set 'sort', sort
    $location.path '/solar_systems'
