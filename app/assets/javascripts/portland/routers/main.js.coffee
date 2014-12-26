class Portland.Routers.Main extends Backbone.Marionette.AppRouter
  routes:
    '': 'containersIndex'
    'containers': 'containersIndex'

  getRoot: -> '/portland'

  initialize: (options) ->
    @mainLayout = new Portland.Views.Main()
    Portland.app.mainRegion.show(@mainLayout)
    @listenTo(Portland.app.vent, 'router:navigate', @navigateTo)

  navigateTo: (path, options = {}) ->
    @navigate(path, _.defaults({}, options, {trigger: true}))

  containersIndex: () ->
    console.log('containers index')
