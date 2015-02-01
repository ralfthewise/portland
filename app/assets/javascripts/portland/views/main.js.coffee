class Portland.Views.Main extends Backbone.Marionette.LayoutView
  template: 'main'

  regions:
    navbarRegion: '.navbar-region'
    leftNavRegion: '.left-nav-region'
    alertsRegion: '.alerts-region'
    mainContentRegion: '.main-content-region'
    terminalRegion: '.terminal-region'
    filesystemRegion: '.filesystem-region'
    modalRegion:
      selector: '.modal-region'
      regionClass: Portland.Regions.Modal

  onShow: () ->
    @mainContentRouter = new Portland.Routers.MainContent(@mainContentRegion, Portland.app.vent)
    @leftNavRouter = new Portland.Routers.NavLeft(@leftNavRegion, Portland.app.vent)

    @listenTo(Portland.app.vent, 'modal:show', @_showModal)
    @navbarRegion.show(new Portland.Views.Navbar())
    @alertsRegion.show(new Portland.Views.Alerts())

    #@mainContentRegion.show(new Portland.Views.Dashboard())
    #filesystem = new Portland.Models.Filesystem({path: '/'})
    #filesystem.fetch()
    #@filesystemRegion.show(new Portland.Views.Filesystem({collection: new Portland.Collections.Filesystem([filesystem])}))

  _showModal: (modalView) =>
    @modalRegion.show(modalView)
