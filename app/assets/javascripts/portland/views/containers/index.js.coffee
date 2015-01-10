class IndexItem extends Portland.Views.BaseLayout
  template: 'containers/index_item'
  tagName: 'tr'

  behaviors:
    Bindable: {}
    Tooltips: {}

  bindings:
    Id: {selector: '.container-link', attr: 'href', toView: (v) -> "/portland/containers/#{v}"}
    Status: [
      {selector: '.running-item', attr: 'displayed', toView: -> not @model.isRunning()}
      {selector: '.stopped-item', attr: 'displayed', toView: -> @model.isRunning()}
    ]

class Portland.Views.ContainersIndex extends Portland.Views.BaseComposite
  template: 'containers/index'
  childView: IndexItem
  childViewContainer: 'tbody.containers-container'

  initialize: () ->
    @collection = Portland.dockerContainers
