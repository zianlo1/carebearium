class CB.Filters.Base
  constructor: (@options) ->
    @options ||= {}

  filterFunction: (item) -> true

  mapFunction: (item) -> item

  visibleField: -> false

  multiple: false

  filterName: 'Filter'

  settings: -> {}

  templateName: 'slider'

  prepare: ->
