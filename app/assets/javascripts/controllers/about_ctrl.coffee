CB.controller 'AboutCtrl', ($scope, $cookieStore) ->
  $cookieStore.put 'seenAbout', true
