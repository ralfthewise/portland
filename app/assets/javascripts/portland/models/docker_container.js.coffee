class Portland.Models.DockerContainer extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "/docker/containers/#{@get('Id')}/json"

  isRunning: -> @get('Status')?.indexOf('Exited') is 0
  getName: -> if @has('Names') then @get('Names')[0] else @get('Name')
  getCommand: -> if @has('Config') then @get('Config').Cmd?.join(' ') else @get('Command')
  getStatus: ->
    #TODO: calculate this better based on State.StartedAt
    return @get('Status') if @has('Status')
    return 'Up a few seconds' if @get('State')?.Running
    return 'Stopped'

class Portland.Collections.DockerContainer extends Portland.Collections.Base
  model: Portland.Models.DockerContainer
  url:"/docker/containers/json?all=1"

Portland.dockerContainers = new Portland.Collections.DockerContainer()
