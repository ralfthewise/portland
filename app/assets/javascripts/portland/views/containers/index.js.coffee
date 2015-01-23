class IndexItem extends Portland.Views.BaseLayout
  template: 'containers/index_item'
  tagName: 'tr'

  behaviors:
    Bindable: {}
    Tooltips: {}

  events:
    'click .stop-btn': '_stopContainer'

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'

  _stopContainer: -> @model.stop()

class Portland.Views.ContainersIndex extends Portland.Views.BaseComposite
  template: 'containers/index'
  childView: IndexItem
  childViewContainer: 'tbody.containers-container'

  initialize: () ->
    @collection = Portland.dockerContainers
