Portland.Traits.CachableModel =
  # this trait allows you to do things like:
  #   MarionetteApp.Models.MyModel.create({name: 'foo'})
  #   MarionetteApp.Models.MyModel.find(21)
  # Mixin like this:
  #   mixin(@, MarionetteApp.Traits.CachableModel)

  cachable: true

  included: (traitable) ->
    traitable.cachedModels = {}

  create: (idOrAttributes, options) -> @_fromAttributes(idOrAttributes, options)
  find: (idOrAttributes, options) -> @_fromAttributes(idOrAttributes, options)

  _fromAttributes: (idOrAttributes, options = {}) ->
    #determine our attributes hash since idOrAttributes can be undefined, an id, or a hash
    attributes = switch
      when not idOrAttributes? then {}
      when _.isObject(idOrAttributes) then idOrAttributes
      else
        (a = {})[@::.idAttribute] = idOrAttributes
        a

    #lookup our cached model
    id = attributes[@::.idAttribute]
    if id?
      model = @cachedModels[id]
      model = (@cachedModels[id] = new @(attributes, options)) if not model?
    else
      model = new @(attributes, options)
      model.once("change:#{model.idAttribute}", => @cachedModels[model.id] = model)
    _fetchIfNeeded(model, options)
    return model

_fetchIfNeeded = (model, options) ->
  return unless model?
  if options.fetch is true
    model.fetch()
  else if options.fetch isnt false
    # fetch if it only has default values
    defaultKeys = _.union([model.idAttribute],_.keys(_.result(model,'defaults')||{}))
    model.fetch() if (not model.isNew() and _.isEmpty(_.omit(model.attributes, defaultKeys)))
