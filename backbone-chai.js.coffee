
_.extend window.chai.Assertion.prototype,

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


