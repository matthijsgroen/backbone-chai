#= require ./../chai-backbone

describe 'Chai-Backbone', ->

  describe 'trigger / when', ->

    it 'asserts if a trigger is fired', ->
      m = new Backbone.Model
      m.should.trigger('change').when ->
        m.set fire: 'trigger'

    it 'asserts if a trigger is not fired', ->
      m = new Backbone.Model
      m.should.not.trigger('change:not_fire').when ->
        m.set fire: 'trigger'

    it 'knows the negate state in the chain', ->
      m = new Backbone.Model
      m.should.trigger('change').and.not.trigger('change:not_fire').when ->
        m.set fire: 'trigger'

  describe 'assert backbone routes', ->
    routerClass = null
    router = null

    before ->
      routerClass = class extends Backbone.Router
        routes:
          'route1/sub': 'subRoute'
          'route2/:par1': 'routeWithArg'
        subRoute: ->
        routeWithArg: (arg) ->

    beforeEach ->
      router = new routerClass

    it 'checks if a method is trigger by route', ->
      "route1/sub".should.route.to router, 'subRoute'
      expect(->
        "route1/ere".should.route.to router, 'subRoute'
      ).to.throw 'expected `route1/ere` to route to subRoute'

    it 'verifies argument parsing', ->
      "route2/argVal".should.route.to router, 'routeWithArg', arguments: ['argVal']
      expect(->
        "route2/ere".should.route.to router, 'routeWithArg', arguments: ['argVal']
      ).to.throw 'expected `routeWithArg` to be called with [ \'argVal\' ], but was called with [ \'ere\' ] instead'

    it 'leaves the `to` keyword working properly', ->
      expect('1').to.be.equal '1'

