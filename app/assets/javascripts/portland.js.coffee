#= require term-v0.0.4
#= require marionette_app
#= require constants
#= require_self
#= require_tree ./portland/lib
#= require_tree ./portland/routers
#= require_tree ./portland/traits
#= require_tree ./portland/behaviors
#= require ./portland/models/base
#= require_tree ./portland/models
#= require_tree ./portland/templates
#= require_tree ./portland/regions
#= require ./portland/views/base
#= require_tree ./portland/views

window.Portland = MarionetteApp

Portland.app.addInitializer(() ->
  @dockerMonitor = new Portland.Lib.DockerMonitor()
)
