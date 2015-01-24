class Portland.Models.Base extends Backbone.Model
  Backbone.Bb.Model.mixin(@::)

class Portland.Collections.Base extends Backbone.Collection
  set: (models, options) ->
    #replace with models from the cache if possible
    if @model.cachable is true
      models = [] unless models?
      models = if _.isArray(models) then models else [models]
      models = _.map models, (m) =>
        if (m instanceof Backbone.Model)
          m
        else
          m = @model::parse(m) if options?.parse
          @model.find(m)
    super(models, options)
