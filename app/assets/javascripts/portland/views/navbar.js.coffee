class Portland.Views.Navbar extends Backbone.Marionette.LayoutView
  template: 'navbar'

  ui:
    btnRun: '.btn-run'
    navLinks: '.navbar a'
    navCollapse: '#navbar-collapse'
    navToggle: '.navbar-toggle'

  events:
    'click @ui.btnRun': '_runContainer'
    'click @ui.navLinks': '_collapseNav'

  _runContainer: ->
    Portland.app.vent.trigger('router:navigate', '/run')

  _collapseNav: ->
    @ui.navToggle.click() if (@ui.navToggle.css('display') isnt 'none' and @ui.navCollapse.css('display') is 'block')
