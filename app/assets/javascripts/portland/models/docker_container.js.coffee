class Portland.Models.DockerContainer extends Portland.Models.Base
  mixin(@, MarionetteApp.Traits.CachableModel)

  idAttribute: 'Id'
  url: -> "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/json"
  path: -> "/portland/containers/#{@id}"

  initialize: (attributes, options) ->
    super
    if not @has('Image')
      if @has('ImageName') then @_lookupImageId() else @once('change:ImageName', @_lookupImageId)

  fetchAndProcess: ->
    @fetch.apply(@, arguments).fail((xhr, textStatus, errorThrown) =>
      Portland.dockerContainers.remove(@) if xhr.status is 404
    )

  isRunning: -> @get('Status')?.indexOf('Exited') isnt 0

  start: ->
    return @save({}, {type: 'POST', url: "#{Constants.DOCKER_API_PREFIX}/containers/#{@id}/start"}).done =>
      @set('Status', 'Up a few seconds')

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
    if response?
      if response.Config?
        #we've inspected one container for a more detailed response
        response.Command = response.Config.Cmd.join(' ') if response.Config.Cmd?
        response.Image = Portland.Models.DockerImage.find(response.Image, {fetch: false})
        if response.State.Running
          response.Status = "Up #{moment(response.State.StartedAt).fromNow(true)}"
        else
          response.Status = "Exited (#{response.State.ExitCode}) #{moment(response.State.FinishedAt).fromNow()}"

      else
        #it's a less detailed response from fetching all the containers
        response.Name = _.last(response.Names) if response.Names?
        response.ImageName = response.Image
        delete response.Image

    return super(response)

  _lookupImageId: =>
    Portland.dockerImages.loaded.done =>
      image = Portland.dockerImages.findWhere({Name: @get('ImageName')})
      @set(Image: image) if image?

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
