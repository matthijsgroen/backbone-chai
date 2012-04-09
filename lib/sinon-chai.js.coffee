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
        messages = sinonMessages @obj, "been called with arguments %*", "%C", false, arguments
        @assert @obj.calledWith(arguments...), messages.affirmative, messages.negative
        this

      before: (otherSpy) ->
        messages = sinonMessages @obj, "been called before %1", "", false, [otherSpy.displayName]
        @assert @obj.calledBefore(otherSpy), messages.affirmative, messages.negative
        this

      after: (otherSpy) ->
        messages = sinonMessages @obj, "been called before %1", "", false, [otherSpy.displayName]
        @assert @obj.calledAfter(otherSpy), messages.affirmative, messages.negative
        this

      exactly: (times) ->
        messages = sinonMessages @obj, "been called exactly #{sinon.timesInWords(times)}", ", but it was called %c%C", false, []
        @assert @obj.callCount == times, messages.affirmative, messages.negative
        this

    }, {
      times: ->
        this

      time: ->
        this
    }

  not_called: ->
    @negate = true
    messages = sinonMessages @obj, "been called", " at least once, but it was never called", false, []
    @assert @obj.called, messages.affirmative, messages.negative
    this

