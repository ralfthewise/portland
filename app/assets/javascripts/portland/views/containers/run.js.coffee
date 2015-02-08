class Portland.Views.ContainersRun extends Portland.Views.BaseLayout
  template: 'containers/run'

  ui:
    imageSelect: '.image-selection'

  onShow: ->
    @ui.imageSelect.selectize(
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      closeAfterSelect: true
      preload: true
      selectOnTab: true
      load: @_searchImages
      score: @_scoreItem
    )

  _searchImages: (query, cb) =>
    if @loaded
      cb([])
    else
      @loaded = true
      Portland.dockerImages.loaded.done ->
        cb(Portland.dockerImages.map((i) -> {id: i.id, name: i.get('Name').toLowerCase()}))

  _scoreItem: (query) ->
    query = query.toLowerCase()
    return (item) ->
      return if item.name.indexOf(query) >= 0 then 1 else 0
