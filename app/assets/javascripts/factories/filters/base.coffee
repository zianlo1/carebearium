CB.Filters ||= {}
class CB.Filters.Base
  constructor: (@options) ->

  filterFunction: (item) -> true

  mapFunction: (item) -> item

  visibleFields: -> {}
