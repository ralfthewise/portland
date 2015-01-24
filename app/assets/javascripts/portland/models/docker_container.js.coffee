class Portland.Models.DockerContainer extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/json"
  path: -> "/portland/containers/#{@id}"

  fetchAndProcess: ->
    @fetch.apply(@, arguments).fail((xhr, textStatus, errorThrown) =>
      Portland.dockerContainers.remove(@) if xhr.status is 404
    )

  stop: ->
    @save({}, {type: 'POST', url: "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/stop"}).done =>
      @model.set('Status', 'Exited')

  isRunning: -> @get('Status')?.indexOf('Exited') isnt 0

  #fixup stupid docker API responses
  parse: (response) ->
    response.Name = _.last(response.Names) if response.Names?
    response.Command = response.Config.Cmd?.join(' ') if response.Config?

    #TODO: calculate this better based on State.StartedAt
    response.Status = switch
      when response.Status? then response.Status
      when response.State?.Running then 'Up a few seconds'
      else 'Exited'

    return super(response)

class Portland.Collections.DockerContainer extends Portland.Collections.Base
  model: Portland.Models.DockerContainer
  url:"#{Constants.DOCKER_API_PREFIX}/containers/json?all=1"

  comparator: (a, b) ->
    [aRunning, bRunning] = [a.isRunning(), b.isRunning()]
    return -1 if aRunning and not bRunning
    return 1 if not aRunning and bRunning
    return a.get('Name')?.localeCompare(b.get('Name'))

Portland.dockerContainers = new Portland.Collections.DockerContainer()
