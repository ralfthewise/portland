class Portland.Models.DockerContainer extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "/docker/containers/#{@get('Id')}/json"
  path: -> "/portland/containers/#{@id}"

  fetchAndProcess: ->
    @fetch.apply(@, arguments).fail((xhr, textStatus, errorThrown) =>
      Portland.dockerContainers.remove(@) if xhr.status is 404
    )

  isRunning: -> @getStatus()?.indexOf('Exited') isnt 0

  getName: ->
    [name, names] = [@get('Name'), @get('Names')]
    return if name? then name else _.last(names)

  getCommand: ->
    [command, config] = [@get('Command'), @get('Config')]
    return if command? then command else config?.Cmd?.join(' ')

  getStatus: ->
    #TODO: calculate this better based on State.StartedAt
    [status, state] = [@get('Status'), @get('State')]
    return status if status?
    return 'Up a few seconds' if state?.Running
    return 'Exited'

class Portland.Collections.DockerContainer extends Portland.Collections.Base
  model: Portland.Models.DockerContainer
  url:"/docker/containers/json?all=1"

  comparator: (a, b) ->
    [aRunning, bRunning] = [a.isRunning(), b.isRunning()]
    return -1 if aRunning and not bRunning
    return 1 if not aRunning and bRunning
    return a.getName().localeCompare(b.getName())

Portland.dockerContainers = new Portland.Collections.DockerContainer()
