CB.Helpers.mapToSelectChoices = (object) ->
  Lazy({ id: id, text: text } for id, text of object).sortBy((item) -> item.text).toArray()

CB.Helpers.objectToString = (object) ->
  btoa encodeURIComponent escape angular.toJson object

CB.Helpers.stringToObject = (string) ->
  angular.fromJson unescape decodeURIComponent atob string
