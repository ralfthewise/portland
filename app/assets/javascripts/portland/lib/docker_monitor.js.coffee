class Portland.Lib.DockerMonitor
  constructor: ->
    Portland.dockerInfo.fetch()
    @_refresh()

    @queue = {update: {}, remove: {}}

    @dispatcher = new WebSocketRails(window.location.host + '/websocket')
    @eventChannel = @dispatcher.subscribe('docker_events')
    @eventChannel.bind('new', @_onDockerEvent)

  _onDockerEvent: (dockerEvent) =>
    switch dockerEvent.status
      when 'create', 'start', 'die'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        @queue.update[c.id] = c
        @_processQueue()
      when 'destroy'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        Portland.dockerContainers.remove(c)

  _processQueueThrottled: =>
    #process updates
    _.each(@queue.update, (model, id) =>
      model.fetchAndProcess()
      Portland.dockerContainers.add(model)
      delete @queue.update[id]
    )

  _processQueue: _.debounce(@::_processQueueThrottled, 500)

  _refresh: =>
    Portland.dockerImages.fetch()
    Portland.dockerContainers.fetch()
    window.setTimeout(@_refresh, 1000 * 60 * 5)
