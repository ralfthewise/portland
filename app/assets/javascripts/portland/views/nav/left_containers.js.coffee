class ContainerItem extends Portland.Views.BaseView
  template: 'nav/left_container_item'
  tagName: 'li'
  attributes:
    role: 'presentation'
    'data-bb': 'class-active:model.isSelected'

  statusClass: -> if @model.isRunning() then 'label-success' else 'label-danger'

class Portland.Views.NavLeftContainers extends Portland.Views.BaseComposite
  template: 'nav/left_containers'
  childView: ContainerItem
  childViewContainer: 'ul.containers-container'

  initialize: () ->
    @collection = Portland.dockerContainers

  updateActiveContainer: (activeContainerId) ->
    Portland.selectedContainer?.unset('isSelected')
    Portland.selectedContainer = Portland.Models.DockerContainer.find(activeContainerId)
    Portland.selectedContainer.set('isSelected', true)
