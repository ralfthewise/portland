class Portland.Views.ContainersRun extends Portland.Views.BaseLayout
  template: 'containers/run'

  ui:
    imageSelect: '.image-selection'

  onShow: ->
    @ui.imageSelect.typeahead({hint: true, highlight: true, minLength: 1},
      name: 'images'
      displayKey: 'name'
      source: @_searchImages
    )

  _searchImages: (query, cb) ->
    results = []
    Portland.dockerImages.each (image) ->
      imageName = image.get('Name')
      if not query or imageName?.toLowerCase().indexOf(query.toLowerCase()) >= 0
        results.push({name: image.get('Name')})

    cb(results)
