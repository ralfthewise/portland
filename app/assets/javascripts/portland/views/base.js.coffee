class Portland.Views.BaseView extends Backbone.Marionette.ItemView
  Backbone.Bb.View.mixin(@::)

  behaviors: Bindable: {}

class Portland.Views.BaseLayout extends Backbone.Marionette.LayoutView
  Backbone.Bb.View.mixin(@::)

  behaviors: Bindable: {}

class Portland.Views.BaseCollection extends Backbone.Marionette.CollectionView

class Portland.Views.BaseComposite extends Backbone.Marionette.CompositeView
  behaviors:
    Bindable: {}

class Portland.Views.BaseModal extends Portland.Views.BaseLayout
  className: 'modal'
  attributes:
    tabindex: '-1'
    role: 'dialog'
    'aria-hidden': 'true'

  modalOptions:
    backdrop: 'static'
    keyboard: true

  closeModal: -> @$el.modal('hide')
