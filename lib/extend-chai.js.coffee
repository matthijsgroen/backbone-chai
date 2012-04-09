
window.chaiPlugin = (methods, properties = {}) ->
  (chai) ->
    chai.Assertion.prototype[name] = method for name, method of methods
    for name, method of properties
      Object.defineProperty chai.Assertion.prototype, name,
          get: method
          configurable: true

window.scopeChaiChain = (object, methods, properties = {}) ->
  new class
    constructor: ->
      _.extend this, methods
      for name, method of properties
        Object.defineProperty this, name,
            get: method
            configurable: true
      _.defaults this, object

