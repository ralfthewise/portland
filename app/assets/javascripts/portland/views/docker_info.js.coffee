class Portland.Views.DockerInfo extends Portland.Views.BaseLayout
  template: 'docker_info'

  initialize: () ->
    @model = Portland.dockerInfo
