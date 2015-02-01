class Portland.Views.NavLeftMain extends Backbone.Marionette.ItemView
  template: 'nav/left_main'
  tagName: 'ul'
  className: 'nav nav-pills nav-stacked'

  updateActiveView: (activeView) ->
    @$('li').removeClass('active')
    @$(".nav-#{activeView}").addClass('active')
