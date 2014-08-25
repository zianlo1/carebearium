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
      controller: 'SolarSystemsCtrl',
      resolve:
        constraints: (Restangular) -> Restangular.one('constraints').get()
    }).
    otherwise({
      redirectTo: '/solar_systems'
    })
]
