Backbone.Bb.Filters =
  not: (value) -> !value
  equals: (value, compareTo) -> value == compareTo
  notEquals: (value, compareTo) -> value != compareTo
  gt: (value, compareTo) -> value > compareTo
  gte: (value, compareTo) -> value >= compareTo
  lt: (value, compareTo) -> value < compareTo
  lte: (value, compareTo) -> value <= compareTo
