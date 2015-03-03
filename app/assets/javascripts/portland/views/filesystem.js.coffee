class FilesystemItem extends Portland.Views.BaseLayout
  tagName: 'li'
  template: 'filesystem'

  regions:
    childrenRegion: '.children-region'

  events:
    'click': '_toggleExpanded'
    'click .refresh': '_refreshDirectory'

  initialize: (options) ->
    @chooseModel = options.chooseModel

  onShow: () ->
    @childrenRegion.show(new Portland.Views.Filesystem({@chooseModel, collection: @model.get('children')}))

  getSelectedClass: ->
    if @model.get('selected') then 'label label-primary' else ''

  _toggleExpanded: () ->
    if @model.get('type') is 'directory'
      @model.toggleExpanded()
      if @model.get('expanded')
        @model.fetch()
      else
        @model.get('children').reset()
    else
      #mark our model as being selected
      @chooseModel.set('selected_model', @model)
      @model.set('selected', true)

    return false

  displayRefresh: ->
    return @model.get('expanded') and @model.get('type') is 'directory'

  _refreshDirectory: () ->
    @model.fetch()
    return false

class Portland.Views.Filesystem extends Portland.Views.BaseCollection
  childView: FilesystemItem
  tagName: 'ul'
  className: 'list-unstyled'

  initialize: (options) ->
    @chooseModel = options.chooseModel

  childViewOptions: (model, index) ->
    return {@chooseModel}
