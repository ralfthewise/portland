class Portland.Views.ChooseFileModal extends Portland.Views.BaseModal
  template: 'choose_file_modal'

  regions:
    filesystemRegion: '.filesystem-region'

  events:
    'click .btn-choose': '_chooseClicked'

  initialize: () ->
    @model = new Portland.Models.Base()
    @listenTo(@model, 'change:selected_model', @_selectedModelChanged)

  onShow: () ->
    filesystem = new Portland.Models.Filesystem({path: '/'})
    filesystem.fetch()
    @filesystemRegion.show(new Portland.Views.Filesystem({chooseModel: @model, collection: new Portland.Collections.Filesystem([filesystem])}))

  _chooseClicked: ->
    console.log('selected model: ', @model.get('selected_model'))
    @destroy()

  _selectedModelChanged: ->
    @model.previous('selected_model')?.unset('selected')
