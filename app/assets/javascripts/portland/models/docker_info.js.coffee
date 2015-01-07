#= require ./docker_version

class Portland.Models.DockerInfo extends Portland.Models.Base
  idAttribute: 'ID'
  url: '/docker/info'

  initialize: ->
    @set('version', new Portland.Models.DockerVersion())
    super

  fetch: ->
    @get('version').fetch()
    super

Portland.dockerInfo = new Portland.Models.DockerInfo()
