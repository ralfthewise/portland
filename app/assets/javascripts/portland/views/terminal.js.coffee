class Portland.Views.Terminal extends Portland.Views.BaseLayout
  template: 'terminal'

  ui:
    terminalContainer: '.terminal-container'

  onShow: () ->
    #@_initTerminal()

  _initTerminal: () ->
    socket = io('/', {path: '/terminal/socket.io'})
    socket.on('connect', =>
      term = new window.Terminal(
        cols: 80
        rows: 24
        useStyle: true
        screenKeys: true
      )

      term.on('data', (data) -> socket.emit('data', data))
      term.open(@ui.terminalContainer[0])
      term.write('Welcome to term\r\n')

      socket.on('data', (data) -> term.write(data))
      socket.on('disconnect', -> term.destroy())
    )
