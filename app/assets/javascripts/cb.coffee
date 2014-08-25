window.CB = angular.module 'CB', [
  'restangular'
  'ngRoute'
  'ngTable'
  'vr.directives.slider'
]

CB.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/solar_systems/', {
      template: JST['solar_systems']
      controller: 'SolarSystemsCtrl'
    }).
    otherwise({
      redirectTo: '/solar_systems'
    })
]
