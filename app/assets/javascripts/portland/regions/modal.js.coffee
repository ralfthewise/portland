class Portland.Regions.Modal extends Backbone.Marionette.Region
  onShow: ->
    @currentView.$el.modal(@currentView.modalOptions)
    @currentView.$el.on('hidden.bs.modal', @_emptyRegion)
    @listenTo(@currentView, 'before:destroy', @_hideModal)

  _emptyRegion: => @empty()

  _hideModal: =>
    @currentView.$el.off('hidden.bs.modal', @_hideModal)
    @currentView.$el.modal('hide')
