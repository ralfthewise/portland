#= require websocket_rails/main
#= require jquery
#= require moment
#= require bootstrap-sass-official
#= require selectize/standalone/selectize
#= require turbolinks
#= require underscore
#= require backbone
#= require backbone.babysitter
#= require backbone.wreqr
#= require marionette-gem
#= require Backbone.ModelBinder
#= require handlebars.runtime
#= require_tree ./lib
#= require_self

# if https://github.com/rails-assets/rails-assets/issues/203 gets fixed we should go back to #= require backbone.marionette instead of #= require marionette-gem

window.MarionetteApp =
  app: new Backbone.Marionette.Application()
  Lib: {}
  Traits: {}
  Behaviors: {}
  Regions: {}
  Routers: {}
  Models: {}
  Collections: {}
  Views: {}

  initialize: (containersAttributes) ->
    @app.addRegions(
      mainRegion: '#app-region'
    )
    router = new MarionetteApp.Routers.Main()
    urlRoot = router.getRoot()
    @pushStateLinks(@app.vent, urlRoot)
    @app.addInitializer(() =>
      Backbone.history.start({pushState: true, root: urlRoot})
    )
    @app.start()

  pushStateLinks: (vent, urlRoot) ->
    hrefRegex = new RegExp("^#{urlRoot}([/?#].*)?$")
    $(document).on('click', "a[href^='#{urlRoot}']", (event) ->
      # don't trigger when link is clicked with a modifier key
      if (not event.altKey and not event.ctrlKey and not event.metaKey and not event.shiftKey)
        href = $(event.currentTarget).attr('href')
        match = href.match(hrefRegex)
        if match?
          event.preventDefault()
          url = match[1] or '/'
          vent.trigger('router:navigate', url)
    )

Backbone.Marionette.Renderer.render = (template, data) ->
  throw new Error('Argument Error: \'template\' must be defined') unless template?
  throw new Error("Template '#{template}' not found!") unless HandlebarsTemplates[template]?
  return HandlebarsTemplates[template](data)

Backbone.Marionette.Behaviors.behaviorsLookup = () ->
  # TODO: does this work with minification
  return MarionetteApp.Behaviors
