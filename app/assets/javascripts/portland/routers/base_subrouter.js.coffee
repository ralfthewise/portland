class Portland.Routers.BaseSubrouter
  _.extend(@::, Backbone.Events)

  handledRoutes: {}

  constructor: (@region, @vent, options) ->
    for own route, callback of @handledRoutes
      callback = @[callback] unless _.isFunction(callback)
      @listenTo(@vent, "routed:#{route}", callback) if _.isFunction(callback)
    @initialize?.apply(@, arguments)
