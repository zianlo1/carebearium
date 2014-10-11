#= require ./base

class CB.Filters.Agent extends CB.Filters.Base
  prepare: =>
    columnNameParts = []

    if @options.level
      @options.level = parseInt(@options.level, 10)
      columnNameParts.push @options.level

    if @options.division
      @options.division = parseInt(@options.division, 10)
      columnNameParts.push CB.StaticData.AgentDivisions[@options.division]

    if @options.corporation
      @options.corporation = parseInt(@options.corporation, 10)
      columnNameParts.push CB.StaticData.Corporations[@options.corporation]

    @fieldName = "agent_#{@options.level || '_'}_#{@options.division || '_'}_#{@options.corporation || '_'}"
    @columName = "Agent: #{columnNameParts.join ' / '}"

  matcherFunction: (agent) =>
    matches = true

    if @options.level
      matches = agent.level is @options.level

    if matches and @options.division
      matches = matches and agent.division is @options.division

    if matches and @options.corporation
      matches = matches and agent.corporation_id is @options.corporation

    matches

  filterFunction: (item) => Lazy(item.agents).some @matcherFunction

  mapFunction: (item) =>
    item[@fieldName] = Lazy(item.agents).countBy(@matcherFunction).get 'true'
    item

  visibleField: =>
    if @options.level or @options.division or @options.corporation
      field: @fieldName
      text: @columName
      display: (item) => item[@fieldName]

  multiple: true

  filterName: 'Has specific agent'

  settings: =>
    levels: CB.StaticData.AgentLevels
    divisions: CB.Helpers.mapToSelectChoices CB.StaticData.AgentDivisions
    corporations: CB.Helpers.mapToSelectChoices CB.StaticData.Corporations
    corporationName: (id) -> CB.StaticData.Corporations[id]
    name: @filterName

  templateName: 'agent'
