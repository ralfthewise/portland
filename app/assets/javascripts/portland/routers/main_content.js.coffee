class Portland.Routers.MainContent extends Portland.Routers.BaseSubrouter
  handledRoutes:
    'default': '_dashboard'
    'dashboard': '_dashboard'
    'images': '_images'
    'imagesMain': '_imagesMain'
    'containers': '_containers'
    'containersMain': '_containersMain'

  _dashboard: () ->
    @region.show(new Portland.Views.Dashboard())

  _images: () ->
    @region.show(new Portland.Views.ImagesIndex())

  _imagesMain: (id) ->
    model = Portland.Models.DockerImage.find(id, {fetch: true})
    @region.show(new Portland.Views.ImagesMain({model}))

  _containers: () ->
    @region.show(new Portland.Views.ContainersIndex())

  _containersMain: (id) ->
    model = Portland.Models.DockerContainer.find(id, {fetch: true})
    @region.show(new Portland.Views.ContainersMain({model}))
