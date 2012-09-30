#= require sinon-1.4.2

((chaiBackbone) ->
  # Module systems magic dance.
  if (typeof require == "function" && typeof exports == "object" && typeof module == "object")
    # NodeJS
    module.exports = chaiBackbone
  else if (typeof define == "function" && define.amd)
    # AMD
    define -> chaiBackbone
  else
    # Other environment (usually <script> tag): plug in to global chai instance directly.
    chai.use chaiBackbone
)((chai, utils) ->
  inspect = utils.inspect
  flag = utils.flag

  sinonMessages = (spy, action, nonNegatedSuffix, always, args) ->
    verbPhrase = if always then "always have " else "have "
    nonNegatedSuffix = nonNegatedSuffix || ""

    {
      affirmative: spy.printf("expected %n to #{verbPhrase}#{action}#{nonNegatedSuffix}", args...),
      negative: spy.printf("expected %n to not #{verbPhrase}#{action}", args...)
    }

  chai.Assertion.addProperty 'called', ->
    spy = flag(this, 'object')
    flag(this, 'spy-calling', true)
    messages = sinonMessages spy, "been called", " at least once, but it was never called", false, []
    @assert spy.callCount > 0, messages.affirmative, messages.negative

  chai.Assertion.addMethod 'exactly', (times) ->
    spy = flag(this, 'object')
    messages = sinonMessages spy, "been called exactly #{sinon.timesInWords(times)}", ", but it was called %c%C", false, []
    @assert spy.callCount == times, messages.affirmative, messages.negative

  chai.Assertion.addMethod 'before', (otherSpy) ->
    spy = flag(this, 'object')
    messages = sinonMessages spy, "been called before %1", "", false, [otherSpy.displayName]
    @assert spy.calledBefore(otherSpy), messages.affirmative, messages.negative

  chai.Assertion.addMethod 'after', (otherSpy) ->
    spy = flag(this, 'object')
    messages = sinonMessages spy, "been called before %1", "", false, [otherSpy.displayName]
    @assert spy.calledAfter(otherSpy), messages.affirmative, messages.negative
    this

  calledWith = ->
    spy = flag(this, 'object')
    messages = sinonMessages spy, "been called with arguments %*", "%C", false, arguments
    @assert spy.calledWith(arguments...), messages.affirmative, messages.negative
    this
  chai.Assertion.addChainableMethod 'with', calledWith, ->

  chai.Assertion.addMethod 'call', (methodName) ->
    object = flag(this, 'object')
    definedActions = flag(this, 'whenActions') || []
    definedActions.push
      negate: flag(this, 'negate')
      before: ->
        @originalMethod = object[methodName]
        @spy = sinon.spy()
        object[methodName] = @spy
        object.delegateEvents?()
      after: ->
        object[methodName] = @originalMethod
        object.delegateEvents?()
        @spy.should.be.called
    flag(this, 'whenActions', definedActions)

)

