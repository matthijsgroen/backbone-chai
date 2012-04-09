#= require spec_helper

describe "Sinon Chai Matchers", ->

  callback = null

  beforeEach -> callback = sinon.spy()

  describe "#not_called", ->

    it "passes if not called", ->
      expect(-> callback.should.have.been.not_called).to.not.throw()

    it "raises AsserionError if called", ->
      callback()
      expect(-> callback.should.have.been.not_called).throw(/been called/)

  describe "called", ->

    describe "#exactly", ->
      it "raises AssertionError if not called", ->
        expect(-> callback.should.have.been.called.exactly(2).times).to.throw(/been called exactly twice, but it was called 0 times/)

      it "passes if matches", ->
        callback()
        expect(-> callback.should.have.been.called.exactly(1).time).to.not.throw()

      it "raises AssertionError if called more than specified", ->
        callback()
        callback()
        callback()
        callback()
        expect(-> callback.should.have.been.called.exactly(3).times).to.throw(/been called exactly thrice, but it was called 4 times/)

    describe "#before", ->
      second = null

      beforeEach -> second = sinon.spy()

      it "raises AssertionError if first not called", ->
        second()
        expect(-> callback.should.have.been.called.before(second)).to.throw(/been called before/)

      it "passes if second not called", ->
        callback()
        expect(-> callback.should.have.been.called.before(second)).to.not.throw()

      it "raises AssertionError if order is wrong", ->
        second()
        callback()
        expect(-> callback.should.have.been.called.before(second)).to.throw(/been called before/)

      it "passes if second if spies are called in correct order", ->
        callback()
        second()
        expect(-> callback.should.have.been.called.before(second)).to.not.throw()

    describe "#after", ->
      second = null

      beforeEach -> second = sinon.spy()

      it "raises AssertionError if first not called", ->
        second()
        expect(-> callback.should.have.been.called.after(second)).to.throw(/been called before/)

      it "raises AssertionError if second not called", ->
        callback()
        expect(-> callback.should.have.been.called.after(second)).to.throw(/been called before/)

      it "raises AssertionError if order is wrong", ->
        callback()
        second()
        expect(-> callback.should.have.been.called.after(second)).to.throw(/been called before/)

      it "passes if second if spies are called in correct order", ->
        second()
        callback()
        expect(-> callback.should.have.been.called.after(second)).to.not.throw()

    describe "#with", ->

      it "raises AssertionError if callback not called", ->
        expect(-> callback.should.have.been.called.with(1)).to.throw(/been called with arguments/)

      it "passes if parameters match exactly", ->
        callback(1)
        expect(-> callback.should.have.been.called.with(1)).to.not.throw()

      it "raises AssertionError if parameters do not match", ->
        callback(4)
        expect(-> callback.should.have.been.called.with(5)).to.throw(/been called with arguments/)

      it "passes if more than specified parameters are passed", ->
        callback(1,2,3)
        expect(-> callback.should.have.been.called.with(1,2)).to.not.throw()
