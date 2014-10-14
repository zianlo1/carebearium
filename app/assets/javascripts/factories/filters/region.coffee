#= require ./dropdown

class CB.Filters.Region extends CB.Filters.Dropdown
  multiple: false

  promptText: 'Select a region...'

  filterName: 'Region'

  templateName: 'dropdown_multiple'

  dropdownChoices: CB.StaticData.Regions

  visibleField: ->
    field: 'region'
    text: 'Region'
    display: (item) -> item.region

  filterFunction: (item) =>
    if @options.choice.length > 0
      item.region_id.toString() in @options.choice
    else
      true
