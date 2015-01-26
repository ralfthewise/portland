class Portland.Views.ContainersMain extends Portland.Views.BaseLayout
  template: 'containers/main'

  behaviors:
    Bindable: {}
    Tooltips: {}

  regions:
    actionsRegion: '.actions-region'
    terminalRegion: '.terminal-region'

  onShow: () ->
    @actionsRegion.show(new Portland.Views.ContainersActions({@model}))
    @terminalRegion.show(new Portland.Views.Terminal({@model}))

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'
