class FilesystemItem extends Portland.Views.BaseLayout
  tagName: 'li'
  template: 'filesystem'

  regions:
    childrenRegion: '.children-region'

  bindings:
    type: [
      {selector: '.directory', attr: 'displayed', toView: (v) -> v is 'directory'}
      {selector: '.file', attr: 'displayed', toView: (v) -> v is 'file'}
    ]
    expanded: [
      {selector: '.expanded', attr: 'displayed'}
      {selector: '.closed', attr: 'hidden'}
    ]

  events:
    'click': '_toggleExpanded'
    'click .refresh': '_refreshDirectory'

  onShow: () ->
    @childrenRegion.show(new Portland.Views.Filesystem({collection: @model.get('children')}))

  _toggleExpanded: () ->
    if @model.get('type') is 'directory'
      @model.toggleExpanded()
      if @model.get('expanded')
        @model.fetch()
      else
        @model.get('children').reset()
    return false

  _refreshDirectory: () ->
    @model.fetch()
    return false

class Portland.Views.Filesystem extends Portland.Views.BaseCollection
  childView: FilesystemItem
  tagName: 'ul'
  className: 'list-unstyled'
