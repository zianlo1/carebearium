CB.controller 'LinkCtrl', ($routeParams, Storage, FilterWithPreset) ->
  Storage.set 'seenAbout', true

  try
    params = CB.Helpers.stringToObject $routeParams.hash
    FilterWithPreset params.f, params.s
  catch error
    console.log error
