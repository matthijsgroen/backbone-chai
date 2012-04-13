#= require underscore
#= require ./extend-chai

window.backboneChai = chaiPlugin

  # Verifies if the subject fires a trigger 'when' events happen
  #
  # Examples:
  #   model.should.trigger("change", with: [model]).when -> model.set attribute: "value"
  #   model.should.not.trigger("change:thing").when -> model.set attribute: "value"
  #   model.should.trigger("change").and.not.trigger("change:thing").when -> model.set attribute: "value"
  #
  # @param trigger the trigger expected to be fired
  trigger: (trigger, options = {}) ->
    @when_actions ||= []

    # Add a around filter to the when actions
    @when_actions.push {
      @negate

      # set up the callback to trigger
      before: (context) ->
        @callback = sinon.spy()
        context.obj.on trigger, @callback

      # verify if our callback is triggered
      after: (context) ->
        negate = context.negate
        context.negate = @negate
        context.assert @callback.calledOnce,
          "expected to trigger #{trigger}",
          "expected not to trigger #{trigger}"

        if options.with?
          context.assert @callback.calledWith(options.with...),
            "expected trigger to be called with #{chai.inspect options.with}, but was called with #{chai.inspect @callback.args[0]}.",
            "expected trigger not to be called with #{chai.inspect options.with}, but was"
        context.negate = negate
    }
    this

  when: (val) ->
    @when_actions ||= []

    action.before?(this) for action in @when_actions
    val() # execute the 'when'
    action.after?(this) for action in @when_actions
    this

  # Verify if a url fragment is routed to a certain method on the router
  # Options:
  # - you can consider multiple routers to test routing priorities
  # - you can indicate expected arguments to test url extractions
  #
  # Examples:
  #
  #   class MyRouter extends Backbone.Router
  #     routes:
  #       "home/:page/:other": "homeAction"
  #
  #   myRouter = new MyRouter
  #
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction")
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction", arguments: ["stuff", "thing"])
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction", consider: [otherRouterWithPossiblyConflictingRoute])
  #
  route_to: (router, methodName, options = {}) ->
    # move possible active Backbone history out of the way temporary
    current_history = Backbone.history

    # reset history to clear active routes
    Backbone.history = new Backbone.History

    spy = sinon.spy router, methodName # spy on our expected method call
    router._bindRoutes() # inject router routes into our history
    if options.considering? # if multiple routers are provided load their routes aswell
      consideredRouter._bindRoutes() for consideredRouter in options.considering

    # manually set the root option to prevent calling Backbone.history.start() which is global
    Backbone.history.options =
      root: '/'

    # fire our route to test
    Backbone.history.loadUrl @obj

    # set back our history. The spy should have our collected info now
    Backbone.history = current_history
    # restore the router method
    router[methodName].restore()

    # now assert if everything went according to spec
    @assert spy.calledOnce,
      "expected '#{@obj}' to route to #{methodName}",
      "expected '#{@obj}' not to route to #{methodName}"

    # verify arguments if they were provided
    if options.arguments?
      @assert spy.calledWith(options.arguments...),
        "expected '#{methodName}' to be called with #{chai.inspect options.arguments}, but was called with #{chai.inspect spy.args[0]} instead",
        "expected '#{methodName}' not to be called with #{chai.inspect options.arguments}, but was"


