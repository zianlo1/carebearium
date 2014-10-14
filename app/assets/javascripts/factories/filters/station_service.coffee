#= require ./dropdown

class CB.Filters.StationService extends CB.Filters.Dropdown
  promptText: 'Select a service...'

  filterName: 'Has station service'

  dropdownChoices:
    factory: 'Manufacturing'
    insurance: 'Insurance'
    lab: 'Research'
    refinery: 'Refinery'
    repair: 'Repair'
    cloning: 'Cloning'

  filterFunction: (item) =>
    if @options.choice
      Lazy(item.stations).some (station) => station[@options.choice]
    else
      true
