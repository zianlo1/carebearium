CB.directive 'filterWrapper', ->
  filter =
    restrict: 'E'
    transclude: true
    scope:
      filter: '='
      settings: '='
      multicolumn: '='
    template: JST['filters/wrapper']
