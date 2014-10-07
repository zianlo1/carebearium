#= require ./dropdown

class CB.Filters.Region extends CB.Filters.Dropdown
  promptText: 'Select a region...'

  filterName: 'Region'

  dropdownChoices: CB.StaticData.Regions

  mapFunction: (item) ->
    item.region = CB.StaticData.Regions[item.regionID]
    item

  visibleFields: ->
    region:
      text: 'Region'
      display: (item) -> item.region

  filterFunction: (item) =>
    if @options.choice
      item.regionID is parseInt(@options.choice, 10)
    else
      true
