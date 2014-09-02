CB.directive 'filter', ($compile, filterConstraints) ->
  link = (scope, element, attrs) ->
    scope.constraints = filterConstraints[scope.filter.kind]

    switch scope.filter.kind
      when 'foo'
        templateName = 'what'
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
