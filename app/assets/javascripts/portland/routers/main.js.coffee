class Portland.Routers.Main extends Backbone.Marionette.AppRouter
  routes:
    '': 'dashboard'
    'images': 'images'
    'images/:id': 'imagesMain'
    'containers': 'containers'
    'containers/:id': 'containersMain'
    'run(/:imageId)': 'containersRun'

  getRoot: -> '/portland'

  initialize: (options) ->
    mainLayout = new Portland.Views.Main()
    Portland.app.mainRegion.show(mainLayout)
    @listenTo(Portland.app.vent, 'router:navigate', @_navigateTo)
    @on('route', @_onRouted)

  _navigateTo: (path, options = {}) ->
    @navigate(path, _.defaults({}, options, {trigger: true}))

  _onRouted: (routeName, args) ->
    routeName = 'default' if _.isEmpty(routeName)
    Portland.app.vent.trigger("routed:#{routeName}", args...)
