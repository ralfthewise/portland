class Portland.Views.ImagesActions extends Portland.Views.BaseView
  template: 'images/actions'
  tagName: 'span'

  behaviors:
    Bindable: {}
    Tooltips: {}

  events:
    'click .start-btn': '_startImage'
    'click .delete-btn': '_deleteImage'

  _startImage: -> console.log('starting container...')
  _deleteImage: -> @model.delete()
