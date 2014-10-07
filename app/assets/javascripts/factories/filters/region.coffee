#= require ./dropdown

class CB.Filters.Region extends CB.Filters.Dropdown
  promptText: 'Select a region...'

  filterName: 'Region'

  dropdownChoices: CB.StaticData.Regions

  mapFunction: (item) ->
    item.region = CB.StaticData.Regions[item.regionID]
    item

  visibleField: ->
    field: 'region'
    text: 'Region'
    display: (item) -> item.region

  prepare: =>
    @options.choice = parseInt(@options.choice, 10)

  filterFunction: (item) =>
    if @options.choice
      item.regionID is @options.choice
    else
      true
