class ImageItem extends Portland.Views.BaseView
  template: 'nav/left_image_item'
  tagName: 'li'
  attributes:
    role: 'presentation'
    'data-bb': 'class-active:model.isSelected'

class Portland.Views.NavLeftImages extends Portland.Views.BaseComposite
  template: 'nav/left_images'
  childView: ImageItem
  childViewContainer: 'ul.images-container'

  initialize: () ->
    @collection = Portland.dockerImages

  updateActiveImage: (activeImageId) ->
    Portland.selectedImage?.unset('isSelected')
    Portland.selectedImage = Portland.Models.DockerImage.find(activeImageId)
    Portland.selectedImage.set('isSelected', true)
