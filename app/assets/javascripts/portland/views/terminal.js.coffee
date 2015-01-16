class Portland.Views.Terminal extends Portland.Views.BaseLayout
  template: 'terminal'

  ui:
    terminalContainer: '.terminal-container'

  initialize: ->
    @_resizeTerminalDebounced = _.debounce(@_resizeTerminal, 500)

  onShow: ->
    @_initTerminal()
    $(window).on('resize', @_resizeTerminalDebounced)

  onDestroy: ->
    $(window).off('resize', @_resizeTerminalDebounced)
    @ws?.close()

  _initTerminal: () ->
    @ws = new WebSocket("ws://localhost:8000/streaming/logs/#{@model.id}")
    @ws.onopen = @_onWebsocketOpen
    @ws.onmessage = @_onWebsocketData
    @ws.onclose = @_onWebsocketClose

  _onWebsocketOpen: =>
    @term = new window.Terminal(
      cols: 80
      rows: 24
      useStyle: true
      screenKeys: true
    )
    _.defer(@_resizeTerminal)

    @term.on('data', (data) => @ws.send(data))
    @term.open(@ui.terminalContainer[0])

  _onWebsocketData: (data) =>
    @term.write(data.data)

  _onWebsocketClose: =>
    @term.destroy()

  _resizeTerminal: =>
    terminalContainerOffset = @ui.terminalContainer.offset()
    availableWidth = document.documentElement.clientWidth - terminalContainerOffset.left
    availableHeight = document.documentElement.clientHeight - terminalContainerOffset.top
    @term.resize(Math.floor(availableWidth / 7), Math.floor(availableHeight / 16.1))
