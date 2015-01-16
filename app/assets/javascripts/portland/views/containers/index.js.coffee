class IndexItem extends Portland.Views.BaseLayout
  template: 'containers/index_item'
  tagName: 'tr'

  behaviors:
    Bindable: {}
    Tooltips: {}

  bindings:
    Status: [
      {selector: '.running-item', attr: 'displayed', toView: -> not @model.isRunning()}
      {selector: '.stopped-item', attr: 'displayed', toView: -> @model.isRunning()}
    ]

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'

class Portland.Views.ContainersIndex extends Portland.Views.BaseComposite
  template: 'containers/index'
  childView: IndexItem
  childViewContainer: 'tbody.containers-container'

  initialize: () ->
    @collection = Portland.dockerContainers
