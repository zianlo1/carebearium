CB.Filters ||= {}
class CB.Filters.Base
  constructor: (@options) ->
    @options ||= {}

  filterFunction: (item) -> true

  mapFunction: (item) -> item

  visibleFields: -> {}

  multiple: false

  filterName: 'Filter'

  settings: -> {}

  templateName: 'slider'
