class Portland.Models.Base extends Backbone.Model

class Portland.Collections.Base extends Backbone.Collection
  parse: (response) ->
    if @model.cachable is true
      response = _.map(response, (m) => @model.find(m))
    return response
