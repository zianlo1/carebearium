window.CB = angular.module 'CB', [
  'ngRoute'
  'vr.directives.slider'
  'ui.bootstrap'
  'ui.select'
  'ngCookies'
  'angulartics'
  'angulartics.google.analytics'
  'ngAnimate'
]

CB.StaticData = CBStaticPreload
CB.Filters = {}
CB.Helpers = {}

CB.config ($routeProvider) ->
  $routeProvider.
    when('/solar_systems/',
      template: JST['solar_systems']
      controller: 'SolarSystemsCtrl'
    ).
    when('/solar_systems/:id',
      template: JST['solar_system']
      controller: 'SolarSystemCtrl'
      resolve:
        solarSystem: (SolarSystems, $route) -> SolarSystems.findOne $route.current.params.id
    ).
    when('/about/',
      template: JST['about']
      controller: 'AboutCtrl'
    ).
    when('/news/:date?',
      template: JST['news']
      controller: 'NewsCtrl'
    ).
    when('/link/:hash',
      template: JST['link']
      controller: 'LinkCtrl'
    ).
    otherwise({
      redirectTo: '/about'
    })

CB.config ($locationProvider) ->
  $locationProvider.html5Mode(true)

CB.config ($analyticsProvider) ->
  $analyticsProvider.firstPageview(true)
  $analyticsProvider.withAutoBase(true)
