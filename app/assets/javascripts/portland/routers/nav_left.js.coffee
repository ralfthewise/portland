class Portland.Routers.NavLeft extends Portland.Routers.BaseSubrouter
  handledRoutes:
    'default': '_dashboard'
    'dashboard': '_dashboard'
    'images': '_images'
    'imagesMain': '_imagesMain'
    'containers': '_containers'
    'containersMain': '_containersMain'
    'containersRun': '_containers'

  _dashboard: () ->
    if @_shouldShowView(Portland.Views.NavLeftMain)
      @region.show(new Portland.Views.NavLeftMain())
    @region.currentView.updateActiveView('dashboard')

  _images: () ->
    if @_shouldShowView(Portland.Views.NavLeftMain)
      @region.show(new Portland.Views.NavLeftMain())
    @region.currentView.updateActiveView('images')

  _imagesMain: (id) ->
    if @_shouldShowView(Portland.Views.NavLeftImages)
      @region.show(new Portland.Views.NavLeftImages())
    @region.currentView.updateActiveImage(id)

  _containers: () ->
    if @_shouldShowView(Portland.Views.NavLeftMain)
      @region.show(new Portland.Views.NavLeftMain())
    @region.currentView.updateActiveView('containers')

  _containersMain: (id) ->
    if @_shouldShowView(Portland.Views.NavLeftContainers)
      @region.show(new Portland.Views.NavLeftContainers())
    @region.currentView.updateActiveContainer(id)

  _shouldShowView: (viewType) ->
    not (@region.currentView? and @region.currentView instanceof viewType)
