class Portland.Views.ContainersMain extends Portland.Views.BaseLayout
  template: 'containers/main'

  behaviors:
    Bindable: {}
    Tooltips: {}

  regions:
    terminalRegion: '.terminal-region'

  onShow: () ->
    @terminalRegion.show(new Portland.Views.Terminal({@model}))

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'
