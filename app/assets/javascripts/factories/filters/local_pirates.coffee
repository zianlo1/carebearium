#= require ./dropdown

class CB.Filters.LocalPirates extends CB.Filters.Dropdown
  multiple: false

  promptText: 'Select pirate faction...'

  filterName: 'Local pirates'

  templateName: 'dropdown_multiple'

  dropdownChoices: CB.StaticData.PirateNames

  visibleField: ->
    field: 'pirate_name'
    text: 'Pirates'
    display: (item) -> item.pirate_name

  filterFunction: (item) =>
    if @options.choice.length > 0
      item.pirate_id.toString() in @options.choice
    else
      true
