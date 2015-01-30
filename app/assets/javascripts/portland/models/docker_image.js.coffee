class Portland.Models.DockerImage extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "#{Constants.DOCKER_API_PREFIX}/images/#{@id}/json"
  path: -> "/portland/images/#{@id}"

  getCreated: ->
    created = @get('Created')
    return (if _.isNumber(created) then moment(created, 'X') else moment(created)).fromNow()

  getSize: ->
    size = Math.floor(Number(@get('VirtualSize')) / (1024 * 1024))
    return "#{size}MB"

  parse: (response) ->
    if response?
      response.Name = _.last(response.RepoTags)
    return super(response)

class Portland.Collections.DockerImage extends Portland.Collections.Base
  model: Portland.Models.DockerImage
  url:"#{Constants.DOCKER_API_PREFIX}/images/json"

  initialize: ->
    @loaded = $.Deferred()
    @once 'sync', => @loaded.resolve()

Portland.dockerImages = new Portland.Collections.DockerImage()
