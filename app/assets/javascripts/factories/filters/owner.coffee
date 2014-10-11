#= require ./dropdown

class CB.Filters.Owner extends CB.Filters.Dropdown
  multiple: false

  promptText: 'Select owner...'

  filterName: 'Owner'

  dropdownChoices: CB.StaticData.SolarSystemOwnerNames

  visibleField: ->
    field: 'owner'
    text: 'Owner'
    display: (item) -> item.owner

  prepare: =>
    @options.choice = parseInt(@options.choice, 10) if @options.choice

  filterFunction: (item) =>
    if @options.choice
      item.owner_id is @options.choice
    else
      true
