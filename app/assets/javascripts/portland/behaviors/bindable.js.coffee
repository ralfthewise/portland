class Portland.Behaviors.Bindable extends Backbone.Marionette.Behavior
  defaults:
    skipDefault: false

  onRender: () ->
    @view.initBindings?()
    if @view.model? or @view.bindings?
      @binders ?= {}

      # collect our bindings from our view
      viewBindings = [{}]
      if @view.bindings?
        viewBindings = if _.isFunction(@view.bindings) then @view.bindings.call(@view, @) else @view.bindings
      viewBindings = [viewBindings] unless _.isArray(viewBindings)

      # now apply them
      _.each(viewBindings, (binding) =>
        model = binding.model or @view.model
        skipDefault = binding.skipDefault is true or @options.skipDefault is true
        modelBinding = binding.modelBinding or binding
        if @binders[model.cid]?
          @binders[model.cid].unbind()
        else
          @binders[model.cid] = new Backbone.ModelBinder()
        @_initializeBinder(model, @getBindings(modelBinding, skipDefault))
      )

  getBindings: (modelBinding, skipDefault = false) ->
    defaultBindings = @getDefaultBindings()
    bindings = if skipDefault then {} else defaultBindings
    _.each(modelBinding, (bindingInfo, modelAttr) =>
      bindingInfo = [bindingInfo] unless _.isArray(bindingInfo)
      bindings[modelAttr] = if skipDefault then [] else _.compact(_.flatten([defaultBindings[modelAttr]]))
      _.each(bindingInfo, (bindingItem) =>
        selector = (if bindingItem.selector? then bindingItem.selector else "[name=\"#{modelAttr}\"]")
        bindings[modelAttr].push(@createBinding(selector, bindingItem.attr, bindingItem.toView, bindingItem.toModel))
      )
    )
    return bindings

  getDefaultBindings: () ->
    return Backbone.ModelBinder.createDefaultBindings(@view.el, 'name')

  # Used to setup two-way binding between a Backbone model and view
  # Parameters:
  #   selector - css selector of element(s) in the view to bind to
  #   attribute - attribute of the element(s) matched by the selector that should be bound
  #       possible values: html, text, enabled, displayed, hidden, class, css:<css attribute>, any html attribute
  #   modelToViewCallback - function that will be called to manipulate the value as it flows from the model to the view
  #   viewToModelCallback - function that will be called to manipulate the value as it flows from the view to the model
  #
  # Examples:
  #   createBinding('h2.description') #just set the text content of the <h2>
  #   createBinding('.btn-save', 'enabled', (v) -> v isnt '') #enable the button if the model value isn't ''
  #   createBinding('.help-text', 'css:opacity', () => if @model.get('is_new') then 0.7 else 0.2)
  #   createBinding('i.status-icon', 'class', (v) -> if v is 'complete' then 'icon-ok' else 'icon-warn')
  createBinding: (selector, attribute, modelToViewCallback, viewToModelCallback) ->
    [elAttribute, cssAttribute] = if attribute? then attribute.split(':') else []
    binding =
      selector: selector
      elAttribute: elAttribute
      cssAttribute: cssAttribute
      converter: (direction, value, attributeName, model) =>
        if direction is Backbone.ModelBinder.Constants.ModelToView
          return modelToViewCallback.call(@view, value, model) if _.isFunction(modelToViewCallback)
          return value
        else if direction is Backbone.ModelBinder.Constants.ViewToModel
          return viewToModelCallback.call(@view, value, model) if _.isFunction(viewToModelCallback)
          return value
        return value
    return binding

  _initializeBinder: (model, bindings) ->
    # by default ModelBinder doesn't handle contenteditable elements, this makes sure it does
    modelBinderTriggers =
      '': 'change'
      '[contenteditable]': 'blur'
    @binders[model.cid].bindCustomTriggers(model, @view.el, modelBinderTriggers, bindings)
