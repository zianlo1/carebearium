#= require ./dropdown

class CB.Filters.SystemFeature extends CB.Filters.Dropdown
  promptText: 'Select a feature...'

  filterName: 'Has system feature'

  dropdownChoices:
    ice: 'Can spawn ice belts'
    player_owned: 'Owned by player alliance'
    npc_owned: 'Owned by NPCs'

  filterFunction: (item) =>
    if @options.choice
      item[@options.choice]
    else
      true
