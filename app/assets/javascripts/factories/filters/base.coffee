class CB.Filters.Base
  constructor: (@options) ->
    @options ||= {}

  filterFunction: (item) -> true

  visibleField: -> false

  multiple: false

  filterName: 'Filter'

  settings: -> {}

  prepare: ->
