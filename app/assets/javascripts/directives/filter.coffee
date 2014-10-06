CB.directive 'filter', ($compile, FilterManager) ->
  link = (scope, element, attrs) ->
    instance = new FilterManager[scope.filter.kind](scope.filter)

    scope.filter   = instance.options
    scope.settings = instance.settings()

    # scope.constraints = filterConstraints[scope.filter.kind]
    # switch scope.filter.kind
    #   when 'region'
    #     templateName = 'region'
    #   when 'jumps'
    #     templateName =  'jumps'
    #     scope.systemNames = []
    #     scope.autocompleteSystemNames = CBAutocomplete 'solar_systems/names', (results) -> scope.systemNames = results
    #     scope.filter.min ||= scope.constraints.min
    #     scope.filter.max ||= scope.constraints.max
    #   when 'agent'
    #     templateName = 'agent'
    #   when 'station_service'
    #     templateName = 'station_service'
    #   when 'system_feature'
    #     templateName = 'system_feature'
    #   else
    #     templateName = 'slider'
    #     scope.translate = (val) -> parseFloat(val) / scope.constraints.scale
    #     scope.filter.min ||= scope.constraints.min
    #     scope.filter.max ||= scope.constraints.max

    element.html JST["filters/#{instance.templateName}"]()

    $compile(element.contents())(scope)

  filter =
    restrict: 'E'
    link: link
