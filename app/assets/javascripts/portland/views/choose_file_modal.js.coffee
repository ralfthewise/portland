class Portland.Views.ChooseFileModal extends Portland.Views.BaseModal
  template: 'choose_file_modal'

  regions:
    filesystemRegion: '.filesystem-region'

  events:
    'click .btn-choose': '_chooseClicked'

  onShow: () ->
    filesystem = new Portland.Models.Filesystem({path: '/'})
    filesystem.fetch()
    @filesystemRegion.show(new Portland.Views.Filesystem({collection: new Portland.Collections.Filesystem([filesystem])}))

  _chooseClicked: ->
    @destroy()
