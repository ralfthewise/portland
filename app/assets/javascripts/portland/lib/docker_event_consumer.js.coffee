class Portland.Lib.DockerEventConsumer
  constructor: ->
    @dispatcher = new WebSocketRails(window.location.host + '/websocket')
    @eventChannel = @dispatcher.subscribe('docker_events')
    @eventChannel.bind('new', @_onDockerEvent)

  _onDockerEvent: (dockerEvent) ->
    console.log(dockerEvent)
    console.log(dockerEvent.status)
    switch dockerEvent.status
      when 'create', 'start', 'die'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        c.fetch()
        Portland.dockerContainers.add(c)
      when 'destroy'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        Portland.dockerContainers.remove(c)
