bindingRegex = /^([\w-]+):([\w.-]+)(?:\|([\w-]+))?$/

#constructs a closure to propogate Backbone changes to the view
constructCallbackToPropagateBbChangesToView = (view, $el, elAttribute, bindingProperties, filter) ->
  return ->
    result = view
    _.find(bindingProperties, (property) ->
      switch

        #handle the case where it's a method or property
        when result[property]?
          result = _.result(result, property)
          return not result?

        #handle the case where it's a model.get()
        when result instanceof Backbone.Model
          result = result.get(property)
          return not result?

        #otherwise we don't know what to do, consider it to be null and break out of the loop
        else
          result = null
          return true
    )

    #now actually update the view with the value
    updateView($el, elAttribute, filter, result)

constructCallbackToAttachBindingsToView = (view, toView, attachedBindings, bindingProperties) ->
  attachBindings = ->
    toView()
    view.stopListening(b.model, "change:#{b.property}", b.callback) while b = attachedBindings.pop()
    bindingChain = []
    context = view
    chainIncomplete = _.find(bindingProperties, (property) ->
      switch
        when context instanceof Backbone.View
          return true unless context[property]?
          context = processPropertyOfBackboneContext(bindingChain, context, context.model, property)
          return false
        when context instanceof Backbone.Model
          if context[property]?
            context = processPropertyOfBackboneContext(bindingChain, context, context, property)
          else
            bindingChain.push({model: context, property})
            context = context.get(property)
          return false
        when not context?
          return true
        else
          context = context[property]
          return false
    )

    #if we made it down the entire chain, let's setup our Backbone event listener to update the view
    if not chainIncomplete?
      bindingLeaf = bindingChain.pop()
      view.listenTo(bindingLeaf.model, "change:#{bindingLeaf.property}", toView) if bindingLeaf?
      attachedBindings.push({model: bindingLeaf.model, property: bindingLeaf.property, callback: toView})

    #any node above the leaf node we setup our Backbone event listener to re-attach bindings
    #eg: if we're binding to 'model.manager.name', and 'manager' changes, we need to re-attach to the new manager model
    _.each(bindingChain, (bindingNode) ->
      view.listenTo(bindingNode.model, "change:#{bindingNode.property}", attachBindings)
      attachedBindings.push({model: bindingNode.model, property: bindingNode.property, callback: attachBindings})
    )

  return attachBindings

updateView = ($el, elAttribute, filter, value) ->
  $el.text(if value? then value.toString() else '')

processPropertyOfBackboneContext = (bindingChain, context, model, property) ->
  if _.isFunction(context[property])
    model?.startRecording?()
    result = context[property].call(context)
    if model?.finishRecording?
      modelProperties = model.finishRecording()
      _.each(modelProperties, (ignored, modelProperty) -> bindingChain.push({model, property: modelProperty}))
    return result
  else
    return context[property]

initBindings = (view) ->
  #remove existing bindings
  while bindingChain = view._attachedBindings.pop()
    view.stopListening(b.model, "change:#{b.property}", b.callback) while b = bindingChain.pop()

  view.$el.find('[data-bb]').each ->
    $el = $(@)
    for binding in $el.data('bb')?.split(',')
      bindingArray = binding.match(bindingRegex)
      throw new Error("Unable to parse binding: #{binding}") unless bindingArray?
      elAttribute = bindingArray[1]
      bindingSource = bindingArray[2]
      bindingSourceProps = bindingSource.split('.')
      filter = bindingArray[3]

      toView = constructCallbackToPropagateBbChangesToView(view, $el, elAttribute, bindingSourceProps, filter)

      view._attachedBindings.push(bindingChain = [])
      attachBindings = constructCallbackToAttachBindingsToView(view, toView, bindingChain, bindingSourceProps)
      attachBindings()

viewMixin =
  _attachedBindings: []
  initBindings: -> initBindings(@)

class Backbone.Bb.View extends Backbone.View
  @mixin: (target) ->
    Backbone.Bb.mixin(target, viewMixin) if target?
    return viewMixin
  @mixin(@::)
