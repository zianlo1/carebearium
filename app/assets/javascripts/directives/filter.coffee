CB.directive 'filter', ($compile, FilterManager) ->
  link = (scope, element, attrs) ->
    instance = new FilterManager[scope.filter.kind](scope.filter)

    scope.filter          = instance.options
    scope.settings        = instance.settings()
    scope.settings.remove = scope.$parent.removeFilter

    element.html JST["filters/#{instance.templateName}"]()

    $compile(element.contents())(scope)

  filter =
    restrict: 'E'
    link: link
