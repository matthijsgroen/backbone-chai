Backbone Chai
=============

Some matchers to help testing backbone structures.

Usage
=====

    #= require backbone-chai
    chai.use backboneChai

Triggers
--------

    model.should.trigger("change").when -> model.set attribute: "value"

this can also be chained further:

    model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
    model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"

Sinon
-----

Matchers have also been added for sinonjs. 

  #= require sinon-chai
  chai.use sinonChai

These are not complete yet, see tests and code for details.


