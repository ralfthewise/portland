class Portland.Lib.DockerMonitor
  constructor: ->
    Portland.dockerInfo.fetch()
    @_refresh()
    @dispatcher = new WebSocketRails(window.location.host + '/websocket')
    @eventChannel = @dispatcher.subscribe('docker_events')
    @eventChannel.bind('new', @_onDockerEvent)

  _onDockerEvent: (dockerEvent) ->
    switch dockerEvent.status
      when 'create', 'start', 'die'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        c.fetch()
        Portland.dockerContainers.add(c)
      when 'destroy'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        Portland.dockerContainers.remove(c)

  _refresh: =>
    Portland.dockerImages.fetch()
    Portland.dockerContainers.fetch()
    window.setTimeout(@_refresh, 1000 * 60 * 5)
