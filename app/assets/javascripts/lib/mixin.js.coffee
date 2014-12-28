window.mixin = (target, trait) ->
  for own key, value of trait when key isnt 'included'
    # Assign properties to the prototype
    target[key] = value
    # to enforce the fat arrow behavior
    # target::[key] = (args...) -> value.apply(target, args)

  trait.included?.call(trait, target)
  return target
