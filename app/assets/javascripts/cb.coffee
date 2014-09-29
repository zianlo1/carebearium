window.CB = angular.module 'CB', [
  'restangular'
  'ngRoute'
  'vr.directives.slider'
  'ui.bootstrap'
  'ui.select'
  'ngCookies'
  'angulartics'
  'angulartics.google.analytics'
  'ngAnimate'
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
    when('/news/:date?',
      template: JST['news']
      controller: 'NewsCtrl'
    ).
    otherwise({
      redirectTo: '/solar_systems'
    })

CB.config ($analyticsProvider) ->
  $analyticsProvider.firstPageview(true)
  $analyticsProvider.withAutoBase(true)

CB.run ($rootScope, $location, Storage, $window) ->
  $rootScope.$on "$routeChangeStart", (event, next, current) ->
    unless Storage.get('seenAbout') or next.$$route.controller is 'AboutCtrl'
      $location.path "/about/"
