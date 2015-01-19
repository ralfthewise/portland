class Portland.Routers.Main extends Backbone.Marionette.AppRouter
  routes:
    '': 'dashboard'
    'images': 'images'
    'images/:id': 'imagesMain'
    'containers': 'containers'
    'containers/:id': 'containersMain'

  getRoot: -> '/portland'

  initialize: (options) ->
    @mainLayout = new Portland.Views.Main()
    Portland.app.mainRegion.show(@mainLayout)
    @listenTo(Portland.app.vent, 'router:navigate', @navigateTo)

  navigateTo: (path, options = {}) ->
    @navigate(path, _.defaults({}, options, {trigger: true}))

  dashboard: () ->
    @mainLayout.mainContentRegion.show(new Portland.Views.Dashboard())

  images: () ->
    @mainLayout.mainContentRegion.show(new Portland.Views.ImagesIndex())

  imagesMain: (id) ->
    model = Portland.Models.DockerImage.find(id, {fetch: true})
    @mainLayout.mainContentRegion.show(new Portland.Views.ImagesMain({model}))

  containers: () ->
    @mainLayout.mainContentRegion.show(new Portland.Views.ContainersIndex())

  containersMain: (id) ->
    model = Portland.Models.DockerContainer.find(id, {fetch: true})
    @mainLayout.mainContentRegion.show(new Portland.Views.ContainersMain({model}))
