window.CB = angular.module 'CB', [
  'restangular'
  'ngRoute'
  'ngTable'
  'vr.directives.slider'
  'ui.bootstrap'
  'ui.select'
  'ngCookies'
  'angulartics'
  'angulartics.google.analytics'
]

CB.config ($routeProvider) ->
  $routeProvider.
    when('/solar_systems/',
      template: JST['solar_systems']
      controller: 'SolarSystemsCtrl'
    ).
    when('/about/',
      template: JST['about']
      controller: 'AboutCtrl'
    ).
    otherwise({
      redirectTo: '/solar_systems'
    })

CB.config ($analyticsProvider) ->
  $analyticsProvider.firstPageview(true)
  $analyticsProvider.withAutoBase(true)

CB.run ($rootScope, $location, storage, $window) ->
  $rootScope.$on "$routeChangeStart", (event, next, current) ->
    unless storage.get('seenAbout') or next.$$route.controller is 'AboutCtrl'
      $location.path "/about/"
