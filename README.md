Backbone Chai
=============

Some matchers to help testing backbone structures.

Triggers
--------

  model.should.trigger("change").when -> model.set attribute: "value"

this can also be chained further:

  model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
  model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"


