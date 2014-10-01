CB.factory 'FilterWithPreset', (Storage, $location) ->
  (filter, order) ->
    Storage.set 'filter', filter
    Storage.set 'order', order
    $location.path '/solar_systems'
