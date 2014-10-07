CB.Helpers.mapToSelectChoices = (object) ->
  Lazy({ id: id, text: text } for id, text of object).sortBy((item) -> item.text).toArray()
