#= require ./docker_version

class Portland.Models.DockerInfo extends Portland.Models.Base
  idAttribute: 'ID'
  url: "#{Constants.DOCKER_API_PREFIX}/info"

  initialize: ->
    @set('version', new Portland.Models.DockerVersion())
    super

  fetch: ->
    @get('version').fetch()
    super

  getRam: ->
    ram = Math.floor(Number(@get('MemTotal')) / (1024 * 1024))
    return "#{ram}MB"

Portland.dockerInfo = new Portland.Models.DockerInfo()
