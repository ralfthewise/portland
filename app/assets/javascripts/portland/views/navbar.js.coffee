class Portland.Views.Navbar extends Backbone.Marionette.LayoutView
  template: 'navbar'

  ui:
    navLinks: '.navbar a'
    navCollapse: '#navbar-collapse'
    navToggle: '.navbar-toggle'

  events:
    'click @ui.navLinks': '_collapseNav'

  _collapseNav: () ->
    @ui.navToggle.click() if (@ui.navToggle.css('display') isnt 'none' and @ui.navCollapse.css('display') is 'block')
