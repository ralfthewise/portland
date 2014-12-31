class Portland.Routers.Main extends Backbone.Marionette.AppRouter
  routes:
    '': 'dashboard'
    'containers': 'containers'

  getRoot: -> '/portland'

  initialize: (options) ->
    @mainLayout = new Portland.Views.Main()
    Portland.app.mainRegion.show(@mainLayout)
    @listenTo(Portland.app.vent, 'router:navigate', @navigateTo)

  navigateTo: (path, options = {}) ->
    @navigate(path, _.defaults({}, options, {trigger: true}))

  dashboard: () ->
    @mainLayout.mainContentRegion.show(new Portland.Views.Dashboard())

  containers: () ->
    @mainLayout.mainContentRegion.show(new Portland.Views.ContainersIndex())
