class Portland.Lib.DockerMonitor
  constructor: ->
    @queue = {update: {}, remove: {}}

    Portland.dockerInfo.fetch()
    @_refresh()
    @_initDispatcher()

  _onDockerEvent: (dockerEvent) =>
    switch dockerEvent.status
      when 'create', 'start', 'die'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        @queue.update[c.id] = c
        @_processQueue()
      when 'destroy'
        c = Portland.Models.DockerContainer.find(dockerEvent.id, {fetch: false})
        #trigger a 'destroy' event
        c.stopListening()
        c.trigger('destroy', c, c.collection)

  _processQueueThrottled: =>
    #process updates
    _.each(@queue.update, (model, id) =>
      model.fetchAndProcess()
      Portland.dockerContainers.add(model)
      delete @queue.update[id]
    )

  _processQueue: _.debounce(@::_processQueueThrottled, 2000)

  _refresh: =>
    Portland.dockerImages.fetch()
    Portland.dockerContainers.fetch()
    window.setTimeout(@_refresh, 1000 * 60 * 5)

  _initDispatcher: =>
    if @dispatcher?
      @dispatcher.reconnect()
    else
      @dispatcher = new WebSocketRails(window.location.host + '/websocket')
      @eventChannel = @dispatcher.subscribe('docker_events')
      @eventChannel.bind('new', @_onDockerEvent)
      @dispatcher.bind('connection_error', @_initDispatcher)
