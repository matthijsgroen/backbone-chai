#= require underscore
#= require ./extend-chai

sinonMessages = (spy, action, nonNegatedSuffix, always, args) ->
  verbPhrase = if always then "always have " else "have "
  nonNegatedSuffix = nonNegatedSuffix || ""

  {
    affirmative: spy.printf("expected %n to #{verbPhrase}#{action}#{nonNegatedSuffix}", args...),
    negative: spy.printf("expected %n to not #{verbPhrase}#{action}", args...)
  }

window.sinonChai = chaiPlugin {},

  called: ->
    scopeChaiChain this, {
      with: ->
        messages = sinonMessages @__flags.object, "been called with arguments %*", "%C", false, arguments
        @assert @__flags.object.calledWith(arguments...), messages.affirmative, messages.negative
        this

      before: (otherSpy) ->
        messages = sinonMessages @__flags.object, "been called before %1", "", false, [otherSpy.displayName]
        @assert @__flags.object.calledBefore(otherSpy), messages.affirmative, messages.negative
        this

      after: (otherSpy) ->
        messages = sinonMessages @__flags.object, "been called before %1", "", false, [otherSpy.displayName]
        @assert @__flags.object.calledAfter(otherSpy), messages.affirmative, messages.negative
        this

      exactly: (times) ->
        messages = sinonMessages @__flags.object, "been called exactly #{sinon.timesInWords(times)}", ", but it was called %c%C", false, []
        @assert @__flags.object.callCount == times, messages.affirmative, messages.negative
        this

    }, {
      times: ->
        this

      time: ->
        this
    }

  not_called: ->
    @negate = true
    messages = sinonMessages @__flags.object, "been called", " at least once, but it was never called", false, []
    @assert @__flags.object.called, messages.affirmative, messages.negative
    this

