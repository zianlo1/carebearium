#= require ./dropdown

class CB.Filters.Region extends CB.Filters.Dropdown
  multiple: false

  promptText: 'Select a region...'

  filterName: 'Region'

  dropdownChoices: CB.StaticData.Regions

  visibleField: ->
    field: 'region'
    text: 'Region'
    display: (item) -> item.region

  prepare: =>
    @options.choice = parseInt(@options.choice, 10) if @options.choice

  filterFunction: (item) =>
    if @options.choice
      item.region_id is @options.choice
    else
      true
