#= require_self
#= require ./bb_model
#= require ./bb_view

Backbone.Bb = {}

Backbone.Bb.mixin = (target, trait) ->
  for own key, value of trait
    target[key] = value
  return target
