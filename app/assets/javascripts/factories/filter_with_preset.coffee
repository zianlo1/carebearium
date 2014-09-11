CB.factory 'FilterWithPreset', (Storage, $location) ->
  (filter, order) ->
    Storage.set 'filters', filter
    Storage.set 'order', order
    $location.path '/solar_systems'
