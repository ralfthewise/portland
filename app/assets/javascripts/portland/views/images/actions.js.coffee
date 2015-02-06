class Portland.Views.ImagesActions extends Portland.Views.BaseView
  template: 'images/actions'
  tagName: 'span'

  behaviors:
    Bindable: {}
    Tooltips: {}

  events:
    'click .delete-btn': '_deleteImage'

  _deleteImage: -> @model.delete()
