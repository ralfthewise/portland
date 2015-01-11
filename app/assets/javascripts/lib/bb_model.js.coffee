modelMixin =
  startRecording: ->
    accesses = {}

    originalHas = @has
    @has = (attribute) ->
      accesses[attribute] = true
      originalHas.call(@, attribute)

    originalGet = @get
    @get = (attribute) ->
      accesses[attribute] = true
      originalGet.call(@, attribute)

    @finishRecording = ->
      delete @has
      delete @get
      delete @finishRecording
      return accesses

    return

class Backbone.Bb.Model extends Backbone.Model
  @mixin: (target) ->
    Backbone.Bb.mixin(target, modelMixin) if target?
    return modelMixin
  @mixin(@::)
