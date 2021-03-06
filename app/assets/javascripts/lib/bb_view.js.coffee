# some examples of the bindings:
#   text:model.name
#   class-active:!model.selected
#   visible:model.type=='image'
#
# remember, the '(?:...)' syntax creates a non-captured match
bindingRegex = /^([\w-]+):(!?[\w.-]+)(?:\|([\w-]+)|(==|!=|>|>=|<|<=)([^,]+))?$/
classBindingRegex = /^class-([\w-]+)$/
compareToRegex = /^'([^']+)'|"([^"]+)"|(true|false)|([0-9.]+)$/

#constructs a closure to propogate Backbone changes to the view
constructCallbackToPropagateBbChangesToView = (view, $el, elAttribute, bindingProperties, filters) ->
  previousResult = null
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

    _.each(filters, (filter) -> result = Backbone.Bb.Filters[filter.name].call(view, result, filter.compareTo))

    #now actually update the view with the value
    updateView($el, elAttribute, result, previousResult)
    previousResult = result

constructCallbackToAttachBindingsToView = (view, toView, attachedBindings, bindingProperties) ->
  attachBindings = ->
    toView()
    view.stopListening(b.model, "change:#{b.property}", b.callback) while b = attachedBindings.pop()
    bindingChain = []
    context = view
    chainIncomplete = _.find(bindingProperties, (property) ->
      switch
        #we're dealing with a Backbone.View, let's get the property or call the function
        when context instanceof Backbone.View
          return true unless context[property]?
          context = processPropertyOfBackboneContext(bindingChain, context, context.model, property)
          return false #not at the end yet


        #we're dealing with a Backbone.Model, we'll check for a property/function, or a get()
        when context instanceof Backbone.Model
          #it's a property/function of the model, just call it directly
          if context[property]?
            context = processPropertyOfBackboneContext(bindingChain, context, context, property)

          #it's an attribute of the model, we'll call get() on it
          else
            bindingChain.push([{model: context, property}])
            context = context.get(property)

          return false #not at the end yet


        #if context is undefined, it means we've reached an undefined part of the chain, we need to stop
        when not context?
          #return true to indicate we're at the end, we can't go any further
          return true


        #we're dealing with a plain old object, just call the method or get the property from it
        else
          return true unless context[property]?
          context = _.result(context, property)
          return false #not at the end yet
    )

    #if we made it down the entire chain, let's setup our Backbone event listener to update the view
    if not chainIncomplete?
      leafBindings = bindingChain.pop()
      if leafBindings?
        _.each(leafBindings, (leafBinding) ->
          view.listenTo(leafBinding.model, "change:#{leafBinding.property}", toView)
          attachedBindings.push({model: leafBinding.model, property: leafBinding.property, callback: toView})
        )

    #any node above the leaf node we need to setup our Backbone event listener to re-attach bindings
    #eg: if we're binding to 'model.manager.name', and 'manager' changes, we need to re-attach to the new manager model
    _.each(bindingChain, (nodeBindings) ->
      _.each(nodeBindings, (nodeBinding) ->
        view.listenTo(nodeBinding.model, "change:#{nodeBinding.property}", attachBindings)
        attachedBindings.push({model: nodeBinding.model, property: nodeBinding.property, callback: attachBindings})
      )
    )

  return attachBindings

parseCompareTo = (compareTo) ->
  throw new Error('Must provide a value to compare to') unless compareTo?
  compareToArray = compareTo.match(compareToRegex)
  return compareToArray[3] == 'true' if compareToArray[3]? #boolean
  return Number(compareToArray[4]) if compareToArray[4]? #number

  #string
  return compareToArray[1] if compareToArray[1]?
  return compareToArray[2] if compareToArray[2]?
  return compareTo #last ditch effort, just return whatever they wrote

mapComparatorFilter = (comparator, compareTo) ->
  return switch comparator
    when '==' then {name: 'equals', compareTo}
    when '!=' then {name: 'notEquals', compareTo}
    when '>' then {name: 'gt', compareTo}
    when '>=' then {name: 'gte', compareTo}
    when '<' then {name: 'lt', compareTo}
    when '<=' then {name: 'lte', compareTo}
    else throw new Error("Unable to parse comparator: #{comparator}")

updateView = ($el, elAttribute, value, previousValue) ->
  switch elAttribute
    #text:model.someProperty
    when 'text' then $el.text(if value? then value.toString() else '')

    #displayed:model.someBooleanProperty
    when 'displayed'
      if !!value then $el.show() else $el.hide()

    #class:model.someProperty
    when 'class'
      $el.removeClass(previousValue) if previousValue?
      $el.addClass(value) if value?

    else

      #class-myclass:model.someProperty
      classMatch = elAttribute.match(classBindingRegex)
      if classMatch?
        className = classMatch[1]
        if !!value then $el.addClass(className) else $el.removeClass(className)

      #everything else (just assume it is an attribute on the element)
      else
        $el.attr(elAttribute, value)

processPropertyOfBackboneContext = (bindingChain, context, model, property) ->
  if _.isFunction(context[property])
    model?.startRecording?()
    result = context[property].call(context)
    if model?.finishRecording?
      modelProperties = model.finishRecording()
      nodeBindings = []
      _.each(modelProperties, (ignored, modelProperty) -> nodeBindings.push({model, property: modelProperty}))
      bindingChain.push(nodeBindings)
    return result
  else
    return context[property]

initBindings = (view) ->
  #remove existing bindings
  while bindingChain = view._attachedBindings.pop()
    view.stopListening(b.model, "change:#{b.property}", b.callback) while b = bindingChain.pop()

  view.$el.find('[data-bb]').addBack('[data-bb]').each ->
    $el = $(@)
    for binding in $el.data('bb')?.split(',')
      bindingArray = binding.match(bindingRegex)
      throw new Error("Unable to parse binding: #{binding}") unless bindingArray?
      filters = []
      elAttribute = bindingArray[1]
      bindingSource = bindingArray[2]
      if bindingSource[0] is '!'
        bindingSource = bindingSource.slice(1)
        filters.push({name: 'not'})
      bindingSourceProps = bindingSource.split('.')
      filters.push({name: bindingArray[3]}) if bindingArray[3]?
      filters.push(mapComparatorFilter(bindingArray[4], parseCompareTo(bindingArray[5]))) if bindingArray[4]?

      toView = constructCallbackToPropagateBbChangesToView(view, $el, elAttribute, bindingSourceProps, filters)

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
