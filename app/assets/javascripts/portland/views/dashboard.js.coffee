class Portland.Views.Dashboard extends Backbone.Marionette.LayoutView
  template: 'dashboard'

  regions:
    recentActivityRegion: '.recent-activity-region'
    dockerInfoRegion: '.docker-info-region'

  onShow: () ->
    @dockerInfoRegion.show(new Portland.Views.DockerInfo())
