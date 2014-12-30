#= require marionette_app
#= require_self
#= require_tree ./portland/routers
#= require_tree ./portland/behaviors
#= require ./portland/models/base
#= require_tree ./portland/models
#= require_tree ./portland/templates
#= require ./portland/views/base
#= require_tree ./portland/views

window.Portland = MarionetteApp

Portland.app.addInitializer(() ->
  Portland.dockerInfo.fetch()
  Portland.dockerContainers.fetch()
)
