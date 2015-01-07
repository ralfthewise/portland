Backbone.Bb = {}

mixin = (target, trait) ->
  for own key, value of trait
    target[key] = value
  return target

bindingRegex = /^([\w-]+):([\w.-]+)(?:\|([\w-]+))?$/

updateView = ($el, elAttribute, filter, value) ->
  $el.text(value)

initBindings = (view) ->
  view.$el.find('[data-bb]').each ->
    $el = $(@)
    for binding in $el.data('bb')?.split(',')
      bindingArray = binding.match(bindingRegex)
      throw new Error("Unable to parse binding: #{binding}") unless bindingArray?
      bindingDestination = bindingArray[1]
      bindingSource = bindingArray[2]
      bindingFilter = bindingArray[3]

      bindingSourceProps = bindingSource.split('.')
      toView = ->
        result = view
        _.find(bindingSourceProps, (bindingSourceProp) ->
          switch
            when result[bindingSourceProp]?
              result = _.result(result, bindingSourceProp)
              return not result?
            when result instanceof Backbone.Model
              result = result.get(bindingSourceProp)
              return not result?
            else
              result = null
              return true
        )
        updateView($el, bindingDestination, bindingFilter, result)
      toView()

      context = view
      _.find(bindingSourceProps, (bindingSourceProp) ->
        switch
          when context instanceof Backbone.View
            return true unless context[bindingSourceProp]?
            if _.isFunction(context[bindingSourceProp])
              context.model?.startRecording?()
              result = context[bindingSourceProp].call(context)
              if context.model?.finishRecording?
                modelAttributes = context.model.finishRecording()
                _.each(modelAttributes, (ignored, attribute) -> view.listenTo(context.model, "change:#{attribute}", toView))
              context = result
            else
              context = context[bindingSourceProp]
            return false
          when context instanceof Backbone.Model
            if context[bindingSourceProp]?
              if _.isFunction(context[bindingSourceProp])
                context.startRecording?()
                result = context[bindingSourceProp].call(context)
                if context.finishRecording?
                  modelAttributes = context.finishRecording()
                  _.each(modelAttributes, (ignored, attribute) -> view.listenTo(context, "change:#{attribute}", toView))
                context = result
              else
                context = context[bindingSourceProp]
            else
              view.listenTo(context, "change:#{bindingSourceProp}", toView)
              context = context.get(bindingSourceProp)
            return false
          when not context?
            return true
          else
            context = context[bindingSourceProp]
            return false
      )

viewMixin =
  initBindings: -> initBindings(@)

modelMixin =
  startRecording: ->
    accesses = {}
    originalGet = @get
    @get = (attribute) ->
      accesses[attribute] = true
      originalGet.call(@, attribute)

    @finishRecording = ->
      delete @get
      delete @finishRecording
      return accesses

    return

class Backbone.Bb.View extends Backbone.View
  @mixin: (target) ->
    mixin(target, viewMixin) if target?
    return viewMixin
  @mixin(@::)

class Backbone.Bb.Model extends Backbone.Model
  @mixin: (target) ->
    mixin(target, modelMixin) if target?
    return modelMixin
  @mixin(@::)
