class Portland.Behaviors.Tooltips extends Backbone.Marionette.Behavior
  ui:
    tooltips: '[data-toggle="tooltip"]'

  onDomRefresh: () ->
    @ui.tooltips.tooltip()
