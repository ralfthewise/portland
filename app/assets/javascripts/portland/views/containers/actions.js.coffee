class Portland.Views.ContainersActions extends Portland.Views.BaseView
  template: 'containers/actions'
  tagName: 'span'

  behaviors:
    Bindable: {}
    Tooltips: {}

  events:
    'click .start-btn': '_startContainer'
    'click .stop-btn': '_stopContainer'
    'click .delete-btn': '_deleteContainer'

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'

  _startContainer: -> @model.start()
  _stopContainer: -> @model.stop()
  _deleteContainer: -> @model.delete()
