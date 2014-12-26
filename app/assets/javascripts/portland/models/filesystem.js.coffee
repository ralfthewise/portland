class Portland.Models.Filesystem extends Portland.Models.Base
  url: -> "/api/filesystem#{@get('path')}"

  initialize: (attributes) ->
    @set('children', new Portland.Collections.Filesystem(attributes?.children))

  parse: (response) ->
    @get('children').reset(response?.children)
    delete response?.children
    response

  toggleExpanded: -> @set('expanded', not @get('expanded'))

class Portland.Collections.Filesystem extends Portland.Collections.Base
  model: Portland.Models.Filesystem

  comparator: (a, b) ->
    if a.get('type') isnt b.get('type')
      return if a.get('type') is 'directory' then -1 else 1
    else
      return if a.get('name') < b.get('name') then -1 else 1
