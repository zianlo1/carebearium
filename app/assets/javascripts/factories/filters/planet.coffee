#= require ./dropdown

class CB.Filters.Planet extends CB.Filters.Dropdown
  promptText: 'Select a type...'

  filterName: 'Has planet type'

  dropdownChoices: CB.StaticData.PlanetTypes

  filterFunction: (item) =>
    if @options.choice
      Lazy(item.planets).some (planet) => planet.type_id is @options.choice
    else
      true
