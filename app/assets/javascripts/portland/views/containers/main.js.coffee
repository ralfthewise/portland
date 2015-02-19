class Portland.Views.ContainersMain extends Portland.Views.BaseLayout
  template: 'containers/main'

  behaviors:
    Bindable: {}
    Tooltips: {}

  regions:
    actionsRegion: '.actions-region'
    terminalRegion: '.terminal-region'

  events:
    'click .tab-logs:not(.active):not(.disabled) a': '_showLogs'
    'click .tab-interact:not(.active):not(.disabled) a': '_showInteract'
    'click .tab-attach:not(.active):not(.disabled) a': '_showAttach'

  onShow: () ->
    @actionsRegion.show(new Portland.Views.ContainersActions({@model}))
    @terminalRegion.show(new Portland.Views.Terminal({@model, type: 'logs'}))

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'

  _showLogs: ->
    @$('.nav-tabs li').removeClass('active')
    @$('.tab-logs').addClass('active')
    @terminalRegion.show(new Portland.Views.Terminal({@model, type: 'logs'}))

  _showInteract: ->
    @$('.nav-tabs li').removeClass('active')
    @$('.tab-interact').addClass('active')
    @terminalRegion.show(new Portland.Views.Terminal({@model, type: 'interact'}))

  _showAttach: ->
    @$('.nav-tabs li').removeClass('active')
    @$('.tab-attach').addClass('active')
    @terminalRegion.show(new Portland.Views.Terminal({@model, type: 'attach'}))
