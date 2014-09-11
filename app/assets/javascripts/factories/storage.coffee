CB.factory 'Storage', ($cookieStore) ->
  get = (key, value) ->
    $cookieStore.get(key) || value

  set = (key, value) ->
    $cookieStore.put key, value

  storage =
    get: get
    set: set
