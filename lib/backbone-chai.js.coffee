#= require underscore
#= require ./extend-chai

window.backboneChai = chaiPlugin

  # Add 'when' around filters to attach
  # a callback that listens to the indicated trigger
  # After the when the callbacks are validated
  # if they where fired
  trigger: (trigger) ->
    @when_actions ||= []

    @when_actions.push {
      @negate

      before: (context) ->
        @callback = sinon.spy()
        context.obj.on trigger, @callback

      after: (context) ->
        negate = context.negate
        context.negate = @negate
        context.assert @callback.calledOnce,
          "expected to trigger #{trigger}",
          "expected not to trigger #{trigger}"
        context.negate = negate
    }
    this

  when: (val) ->
    @when_actions ||= []

    action.before?(this) for action in @when_actions
    val() # execute the 'when'
    action.after?(this) for action in @when_actions
    this

  route_to: (router, methodName) ->
    current_history = Backbone.history
    Backbone.history = new Backbone.History
    spy = sinon.spy router, methodName
    router._bindRoutes()
    Backbone.history.options =
      root: '/'
    Backbone.history.loadUrl @obj
    Backbone.history = current_history
    router[methodName].restore()

    @assert spy.calledOnce,
      "expected '#{@obj}' to route to #{methodName}",
      "expected '#{@obj}' not to route to #{methodName}"

