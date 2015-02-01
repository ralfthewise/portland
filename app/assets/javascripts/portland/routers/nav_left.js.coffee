class Portland.Routers.NavLeft extends Portland.Routers.BaseSubrouter
  handledRoutes:
    'dashboard': '_dashboard'
    'images': '_images'
    'imagesMain': '_imagesMain'
    'containers': '_containers'
    'containersMain': '_containersMain'

  _dashboard: () ->
    @region.show(new Portland.Views.NavLeftMain())

  _images: () ->
    @region.show(new Portland.Views.NavLeftMain())

  _imagesMain: (id) ->
    @region.show(new Portland.Views.NavLeftMain())

  _containers: () ->
    @region.show(new Portland.Views.NavLeftMain())

  _containersMain: (id) ->
    @region.show(new Portland.Views.NavLeftMain())
