class Portland.Views.BaseLayout extends Backbone.Marionette.LayoutView
  Backbone.Bb.View.mixin(@::)

  behaviors:
    Bindable: {}

class Portland.Views.BaseCollection extends Backbone.Marionette.CollectionView

class Portland.Views.BaseComposite extends Backbone.Marionette.CompositeView
  behaviors:
    Bindable: {}
