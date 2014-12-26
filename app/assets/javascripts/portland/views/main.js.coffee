class Portland.Views.Main extends Backbone.Marionette.LayoutView
  template: 'main'

  regions:
    navbarRegion: '.navbar-region'
    alertsRegion: '.alerts-region'
    terminalRegion: '.terminal-region'
    filesystemRegion: '.filesystem-region'

  onShow: () ->
    @navbarRegion.show(new Portland.Views.Navbar())
    @alertsRegion.show(new Portland.Views.Alerts())
    @terminalRegion.show(new Portland.Views.Terminal())
    filesystem = new Portland.Models.Filesystem({path: '/'})
    filesystem.fetch()
    @filesystemRegion.show(new Portland.Views.Filesystem({collection: new Portland.Collections.Filesystem([filesystem])}))
