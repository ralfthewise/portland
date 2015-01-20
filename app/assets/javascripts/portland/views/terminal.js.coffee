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
    [availableWidth, availableHeight] = @_calculateTerminalDimensions()
    @term = new window.Terminal(
      rows: availableWidth
      cols: availableHeight
      useStyle: true
      screenKeys: true
    )
    @term.open(@ui.terminalContainer[0])

    scheme = if window.location.protocol is 'https:' then 'wss' else 'ws'
    @ws = new WebSocket("#{scheme}://#{window.location.host}/streaming/logs/#{@model.id}")
    @ws.onopen = @_onWebsocketOpen
    @ws.onmessage = @_onWebsocketData
    @ws.onclose = @_onWebsocketClose

  _onWebsocketOpen: =>
    @term.on('data', (data) => @ws.send(data))
    @_resizeTerminal() #hopefully this will inform the TTY of our terminal size

  _onWebsocketData: (data) =>
    @term.write(data.data)

  _onWebsocketClose: =>
    @term.destroy()

  _resizeTerminal: =>
    [availableWidth, availableHeight] = @_calculateTerminalDimensions()
    @term.resize(availableWidth, availableHeight)

  _calculateTerminalDimensions: ->
    terminalContainerOffset = @ui.terminalContainer.offset()
    availableWidth = document.documentElement.clientWidth - terminalContainerOffset.left
    availableHeight = document.documentElement.clientHeight - terminalContainerOffset.top
    return [Math.floor(availableWidth / 6.8), Math.floor(availableHeight / 16.1)]
