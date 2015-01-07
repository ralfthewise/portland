class Portland.Views.DockerInfo extends Portland.Views.BaseLayout
  template: 'docker_info'

  initialize: () ->
    @model = Portland.dockerInfo

  getRam: ->
    ram = Math.floor(Number(@model.get('MemTotal')) / (1024 * 1024))
    return "#{ram}MB"
