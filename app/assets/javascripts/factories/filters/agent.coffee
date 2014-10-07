#= require ./base

class CB.Filters.Agent extends CB.Filters.Base
  matcherFunction: (agent) =>
    matches = true

    if @options.level
      matches = agent.level is parseInt(@options.level, 10)

    if matches and @options.division
      matches = matches and agent.division is parseInt(@options.division, 10)

    if matches and @options.corporation
      matches = matches and agent.corporationID is parseInt(@options.corporation, 10)

    matches

  fieldName: =>
    "agent_#{@options.level || '_'}_#{@options.division || '_'}_#{@options.corporation || '_'}"

  filterFunction: (item) => Lazy(item.agents).some @matcherFunction

  mapFunction: (item) =>
    item[@fieldName()] = Lazy(item.agents).countBy(@matcherFunction).get 'true'
    item

  visibleFields: =>
    fields = {}

    if @options.level or @options.division or @options.corporation
      nameParts = []
      nameParts.push @options.level if @options.level
      nameParts.push CB.StaticData.AgentDivisions[@options.division]
      nameParts.push CB.StaticData.Corporations[@options.corporation] if @options.corporation
      fields[@fieldName()] =
        text: "Agent: #{nameParts.join ' / '}"
        display: (item) => item[@fieldName()]

    fields

  multiple: true

  filterName: 'Has specific agent'

  settings: =>
    levels: CB.StaticData.AgentLevels
    divisions: CB.StaticData.AgentDivisions
    corporations: CB.StaticData.Corporations
    name: @filterName

  templateName: 'agent'
