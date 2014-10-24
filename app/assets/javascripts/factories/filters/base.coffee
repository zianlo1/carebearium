class CB.Filters.Base
  constructor: (@options) ->
    @options ||= {}

  filterFunction: (item) -> true

  reversibleFilterFunction: (item) =>
    if @options.reversed
      not @filterFunction item
    else
      @filterFunction item

  visibleField: -> false

  multiple: false

  filterName: 'Filter'

  settings: -> {}

  prepare: ->
