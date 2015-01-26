class IndexItem extends Portland.Views.BaseLayout
  template: 'containers/index_item'
  tagName: 'tr'

  regions: {actionsRegion: '.actions-region'}

  onShow: ->
    @actionsRegion.show(new Portland.Views.ContainersActions({@model}))

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'

class Portland.Views.ContainersIndex extends Portland.Views.BaseComposite
  template: 'containers/index'
  childView: IndexItem
  childViewContainer: 'tbody.containers-container'

  initialize: () ->
    @collection = Portland.dockerContainers
