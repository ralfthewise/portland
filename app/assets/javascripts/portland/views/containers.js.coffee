class Container extends Portland.Views.BaseLayout
  template: 'container'
  tagName: 'tr'

  behaviors:
    Bindable: {}
    Tooltips: {}

  bindings:
    Id: {selector: '.container-link', attr: 'href', toView: (v) -> "/portland/containers/#{v}"}
    Names: {selector: '.container-link', toView: (v) -> v?[0]}
    Status: [
      {selector: '.running-item', attr: 'displayed', toView: -> not @model.isRunning()}
      {selector: '.stopped-item', attr: 'displayed', toView: -> @model.isRunning()}
    ]

class Portland.Views.Containers extends Portland.Views.BaseComposite
  template: 'containers'
  childView: Container
  childViewContainer: 'tbody.containers-container'

  initialize: () ->
    @collection = Portland.dockerContainers
