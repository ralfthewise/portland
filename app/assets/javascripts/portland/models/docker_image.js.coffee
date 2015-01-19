class Portland.Models.DockerImage extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "/docker/images/#{@get('Id')}/json"
  path: -> "/portland/images/#{@id}"

  getName: -> return _.last(@get('RepoTags'))

  getCreated: ->
    created = @get('Created')
    return (if _.isNumber(created) then moment(created, 'X') else moment(created)).fromNow()

  getSize: ->
    size = Math.floor(Number(@get('VirtualSize')) / (1024 * 1024))
    return "#{size}MB"

class Portland.Collections.DockerImage extends Portland.Collections.Base
  model: Portland.Models.DockerImage
  url:"/docker/images/json"

Portland.dockerImages = new Portland.Collections.DockerImage()
