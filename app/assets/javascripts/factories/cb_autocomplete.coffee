CB.factory 'CBAutocomplete', (Restangular) ->
  Restangular.setRequestSuffix '.json'

  (url, callback) ->
    collection = Restangular.all(url)
    (keyword) ->
      collection.getList({q: keyword}).then (data) ->
        callback _.map data, (item) -> item.plain()
