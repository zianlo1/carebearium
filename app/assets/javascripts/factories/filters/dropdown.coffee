#= require ./base

class CB.Filters.Dropdown extends CB.Filters.Base
  multiple: true

  settings: =>
    choices: CB.Helpers.mapToSelectChoices @dropdownChoices
    prompt: @promptText
    name: @filterName

  templateName: 'dropdown'
