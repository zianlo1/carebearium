CB.directive 'filter', ($compile, filterConstraints, CBAutocomplete) ->
  link = (scope, element, attrs) ->
    scope.constraints = filterConstraints[scope.filter.kind]
    console.log scope.filter.kind
    console.log scope.constraints
    switch scope.filter.kind
      when 'region'
        templateName = 'region'
      when 'jumps'
        templateName =  'jumps'
        scope.systemNames = []
        scope.autocompleteSystemNames = CBAutocomplete 'solar_systems/names', (results) -> scope.systemNames = results
        scope.filter.min = scope.constraints.min
        scope.filter.max = scope.constraints.max
      when 'agent'
        templateName = 'agent'
      else
        templateName = 'slider'
        scope.translate = (val) -> parseFloat(val) / scope.constraints.scale
        scope.filter.min = scope.constraints.min
        scope.filter.max = scope.constraints.max

    element.html JST["filters/#{templateName}"]()
    $compile(element.contents())(scope)

  filter =
    restrict: 'E'
    link: link
