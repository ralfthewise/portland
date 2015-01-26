class Portland.Models.DockerContainer extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/json"
  path: -> "/portland/containers/#{@id}"

  fetchAndProcess: ->
    @fetch.apply(@, arguments).fail((xhr, textStatus, errorThrown) =>
      Portland.dockerContainers.remove(@) if xhr.status is 404
    )

  isRunning: -> @get('Status')?.indexOf('Exited') isnt 0

  stop: ->
    deferred = $.Deferred()
    return deferred.resolve() unless @isRunning()
    @save({}, {type: 'POST', url: "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/stop"}).done(=>
      @set('Status', 'Exited')
      deferred.resolve()
    ).fail -> deferred.reject.apply(@, arguments)
    return deferred

  kill: ->
    deferred = $.Deferred()
    return deferred.resolve() unless @isRunning()
    @save({}, {type: 'POST', url: "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/kill"}).done(=>
      @set('Status', 'Exited')
      deferred.resolve()
    ).fail -> deferred.reject.apply(@, arguments)
    return deferred

  delete: ->
    @stop().done =>
      $.ajax({type: 'DELETE', url: "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}?force=1"}).done =>
        Portland.dockerContainers.remove(@)

  #fixup stupid docker API responses
  parse: (response) ->
    return unless response?

    response.Name = _.last(response.Names) if response.Names?
    if response.Config?
      response.Command = response.Config.Cmd?.join(' ')
      response.Image = response.Config.Image

    #TODO: calculate this better based on State.StartedAt
    response.Status = switch
      when response.Status? then response.Status
      when response.State?.Running then 'Up a few seconds'
      else "Exited #{if response.State? then "(#{response.State.ExitCode})" else ''}"

    return super(response)

class Portland.Collections.DockerContainer extends Portland.Collections.Base
  model: Portland.Models.DockerContainer
  url:"#{Constants.DOCKER_API_PREFIX}/containers/json?all=1"

  initialize: (models, options) ->
    super
    @on('change:Status', @_sortModel)

  comparator: (a, b) ->
    [aRunning, bRunning] = [a.isRunning(), b.isRunning()]
    return -1 if aRunning and not bRunning
    return 1 if not aRunning and bRunning
    return a.get('Name')?.localeCompare(b.get('Name'))

  #will cause model to be moved to the correct sorted position
  _sortModel: (model, value, options) =>
    @remove(model)
    @add(model)

Portland.dockerContainers = new Portland.Collections.DockerContainer()
