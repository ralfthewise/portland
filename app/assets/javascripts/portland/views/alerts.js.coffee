class AlertItem extends Backbone.Marionette.ItemView
  template: 'alert'

  events:
    'click button.close': '_dismissAlert'

  ui:
    alert: '.alert'

  onShow: () ->
    #this bit of wonkiness is to allow a slide-down/fade-in effect using CSS3 transitions
    @ui.alert[0].style.display = 'block'
    height = window.getComputedStyle(@ui.alert[0]).height
    @ui.alert[0].style.display = ''
    @ui.alert.css({overflow: 'hidden', height: 0, opacity: 0, 'padding-top': 0, 'padding-bottom': 0, 'margin-bottom': 0, 'border-width': 0})
    setTimeout(=> #have to do these setTimeouts otherwise css/class changes can get applied in the wrong order
      @ui.alert.removeClass('closed').addClass('animated-alert')
      setTimeout(=>
        @ui.alert.css({height, opacity: '', 'padding-top': '', 'padding-bottom': '', 'margin-bottom': '', 'border-width': ''})
        setTimeout((=> @ui.alert.css({overflow: '', height: ''})), 600)
      , 100)
    , 100)

  destroy: () =>
    height = window.getComputedStyle(@ui.alert[0]).height
    @ui.alert.css({overflow: 'hidden', height})
    setTimeout(=>
      @ui.alert.css({height: 0, opacity: 0, 'padding-top': 0, 'padding-bottom': 0, 'margin-bottom': 0, 'border-width': 0})
      setTimeout((=> super), 600)
    , 100)

  _dismissAlert: () ->
    @model.collection.remove(@model)

class Portland.Views.Alerts extends Backbone.Marionette.CollectionView
  childView: AlertItem

  initialize: () ->
    @collection = new Backbone.Collection()

  onShow: () ->
    @listenTo(Portland.app.vent, 'alert:add', @_addAlert)

  _addAlert: (message, type = 'success', duration = 10) =>
    alert = new Backbone.Model({message, type})
    @collection.push(alert)
    setTimeout((=> @collection.remove(alert)), duration * 1000) if duration > 0
