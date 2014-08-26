window.CB = angular.module 'CB', [
  'restangular'
  'ngRoute'
  'ngTable'
  'vr.directives.slider'
  'ui.bootstrap'
  'ngCookies'
]

CB.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/solar_systems/',
      template: JST['solar_systems']
      controller: 'SolarSystemsCtrl'
      resolve:
        constraints: (Restangular) -> Restangular.one('constraints').get()
    ).
    when('/about/',
      template: JST['about']
      controller: 'AboutCtrl'
    ).
    otherwise({
      redirectTo: '/solar_systems'
    })
]).run ($rootScope, $location, $cookieStore, $window) ->
  $rootScope.$on "$routeChangeStart", (event, next, current) ->
    unless $cookieStore.get('seenAbout') or next.$$route.controller is 'AboutCtrl'
      $location.path "/about/"
  $rootScope.$on '$routeChangeSuccess', ->
    $window._gaq.push ['_trackPageview', $location.path()]
