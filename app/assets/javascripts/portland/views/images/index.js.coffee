class IndexItem extends Portland.Views.BaseLayout
  template: 'images/index_item'
  tagName: 'tr'

  regions: {actionsRegion: '.actions-region'}

  onShow: ->
    @actionsRegion.show(new Portland.Views.ImagesActions({@model}))

class Portland.Views.ImagesIndex extends Portland.Views.BaseComposite
  template: 'images/index'
  childView: IndexItem
  childViewContainer: 'tbody.images-container'

  initialize: () ->
    @collection = Portland.dockerImages
