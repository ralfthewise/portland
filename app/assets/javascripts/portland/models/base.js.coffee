class Portland.Models.Base extends Backbone.Model
  Backbone.Bb.Model.mixin(@::)

class Portland.Collections.Base extends Backbone.Collection
  set: (models, options) ->
    #replace with models from the cache if possible
    if @model.cachable is true
      options = _.clone(options or {})
      models = [] unless models?
      models = [models] unless _.isArray(models)
      models = _.map models, (m) =>
        if (m instanceof Backbone.Model)
          m
        else
          m = @model::parse(m) if options.parse
          @model.find(m, {fetch: false})
      options.parse = false #otherwise Backbone will try to parse it again when we call super
    super(models, options)
