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

  getExposedPorts: ->
    return @get('ExposedPorts')?.join(', ')

  parse: (response) ->
    if response?
      if response.Config?
        #we've inspected one image for a more detailed response
        response.ExposedPorts = _.keys(response.Config.ExposedPorts)

      else
        #it's a less detailed response from fetching all the images
        response.Name = _.last(response.RepoTags)
    return super(response)

class Portland.Collections.DockerImage extends Portland.Collections.Base
  model: Portland.Models.DockerImage
  url:"#{Constants.DOCKER_API_PREFIX}/images/json"

  initialize: ->
    @loaded = $.Deferred()
    @once 'sync', => @loaded.resolve()

Portland.dockerImages = new Portland.Collections.DockerImage()
