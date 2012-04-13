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

Routing
-------

    "page/3".should.route_to myRouter, "openPage", arguments: ["3"]
    "page/3".should.route_to myRouter, "openPage", considering: [conflictingRouter]

Sinon
-----

Matchers have also been added for sinonjs. 

    #= require sinon-chai
    chai.use sinonChai

These are not complete yet, see tests and code for details.

    spy.should.have.been.called.exactly(x).times
    spy.should.have.been.called.before otherSpy
    spy.should.have.been.called.after otherSpy
    spy.should.have.been.called.with "argument1", 2, "argument3"
    spy.should.have.been.not_called

