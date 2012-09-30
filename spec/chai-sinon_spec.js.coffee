#= require ./../chai-sinon

describe 'Sinon Chai Matchers', ->

  callback = null

  beforeEach -> callback = sinon.spy()

  describe 'not have been called', ->

    it 'passes if not called', ->
      expect(-> callback.should.not.have.been.called).to.not.throw()

    it 'raises AsserionError if called', ->
      callback()
      expect(-> callback.should.not.have.been.called).throw(/been called/)

  describe 'called', ->

    it "raises AssertionError if not called", ->
      expect(-> callback.should.have.been.called.times).to.throw(/been called at least once, but it was never called/)

    describe '#exactly', ->

      it 'passes if matches', ->
        callback()
        expect(-> callback.should.have.been.called.exactly(1).time).to.not.throw()

      it 'raises AssertionError if called more than specified', ->
        callback()
        callback()
        callback()
        callback()
        expect(-> callback.should.have.been.called.exactly(3).times).to.throw(/been called exactly thrice, but it was called 4 times/)

    describe '#before', ->
      second = null

      beforeEach -> second = sinon.spy()

      it 'passes if second not called', ->
        callback()
        expect(-> callback.should.have.been.called.before(second)).to.not.throw()

      it 'raises AssertionError if order is wrong', ->
        second()
        callback()
        expect(-> callback.should.have.been.called.before(second)).to.throw(/been called before/)

      it 'passes if second if spies are called in correct order', ->
        callback()
        second()
        expect(-> callback.should.have.been.called.before(second)).to.not.throw()

    describe '#after', ->
      second = null

      beforeEach -> second = sinon.spy()

      it 'raises AssertionError if second not called', ->
        callback()
        expect(-> callback.should.have.been.called.after(second)).to.throw(/been called before/)

      it 'raises AssertionError if order is wrong', ->
        callback()
        second()
        expect(-> callback.should.have.been.called.after(second)).to.throw(/been called before/)

      it 'passes if second if spies are called in correct order', ->
        second()
        callback()
        expect(-> callback.should.have.been.called.after(second)).to.not.throw()

    describe '#with', ->

      it 'passes if parameters match exactly', ->
        callback(1)
        expect(-> callback.should.have.been.called.with(1)).to.not.throw()

      it 'raises AssertionError if parameters do not match', ->
        callback(4)
        expect(-> callback.should.have.been.called.with(5)).to.throw(/been called with arguments/)

      it 'passes if more than specified parameters are passed', ->
        callback(1,2,3)
        expect(-> callback.should.have.been.called.with(1,2)).to.not.throw()

  describe 'call', ->

    it 'asserts if a method on provided object is called', ->
      obj =
        method: ->

      obj.should.call('method').when ->
        obj.method()

    it 'raises AssertionError if method was not called', ->
      obj =
        method: ->
      expect(->
        obj.should.call('method').when ->
          "noop"
      ).to.throw /been called/

   it 'can check event calls of Backbone.Views', ->
     viewClass = class extends Backbone.View
       events:
         'click': 'eventCall'
       eventCall: ->

     viewInstance = new viewClass
     viewInstance.should.call('eventCall').when ->
       viewInstance.$el.trigger('click')

