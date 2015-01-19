class IndexItem extends Portland.Views.BaseLayout
  template: 'images/index_item'
  tagName: 'tr'

  behaviors:
    Bindable: {}
    Tooltips: {}

class Portland.Views.ImagesIndex extends Portland.Views.BaseComposite
  template: 'images/index'
  childView: IndexItem
  childViewContainer: 'tbody.images-container'

  initialize: () ->
    @collection = Portland.dockerImages
