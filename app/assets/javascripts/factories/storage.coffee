CB.factory 'Storage', ($cookieStore) ->
  get = (key, value) ->
    try
      $cookieStore.get(key) || value
    catch
      value

  set = (key, value) ->
    $cookieStore.put key, value

  storage =
    get: get
    set: set
