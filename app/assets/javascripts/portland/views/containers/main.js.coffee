class Portland.Views.ContainersMain extends Portland.Views.BaseLayout
  template: 'containers/main'

  behaviors:
    Bindable: {}
    Tooltips: {}

  bindings:
    Names: {selector: '.container-name', toView: (v) -> v?[0]}

  regions:
    terminalRegion: '.terminal-region'

  onShow: () ->
    #@terminalRegion.show(new Portland.Views.Terminal({@model}))
