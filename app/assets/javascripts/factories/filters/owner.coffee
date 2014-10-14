#= require ./dropdown

class CB.Filters.Owner extends CB.Filters.Dropdown
  multiple: false

  promptText: 'Select owner...'

  filterName: 'Owned by'

  templateName: 'dropdown_multiple'

  dropdownChoices: CB.StaticData.SolarSystemOwnerNames

  visibleField: ->
    field: 'owner'
    text: 'Owner'
    display: (item) -> item.owner

  filterFunction: (item) =>
    if @options.choice.length > 0
      item.owner_id.toString() in @options.choice
    else
      true
