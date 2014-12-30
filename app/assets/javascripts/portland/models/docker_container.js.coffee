class Portland.Models.DockerContainer extends Portland.Models.Base
  idAttribute: 'Id'
  url: -> "/docker/containers/#{@get('Id')}/json"

  isRunning: -> @get('Status')?.indexOf('Exited') is 0

class Portland.Collections.DockerContainer extends Portland.Collections.Base
  model: Portland.Models.DockerContainer
  url:"/docker/containers/json?all=1"

Portland.dockerContainers = new Portland.Collections.DockerContainer()
