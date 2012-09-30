Backbone::Chai
==============

- Adds Chai matchers for common backbone assertions
- Adds Chai matchers to assert changes
- Adds Chai matchers for common sinon assertions
- Adds support for Factories

Installation
------------

for using these matchers in Konacha, see [Chai-Backbone-Rails](https://github.com/matthijsgroen/chai-backbone-rails)

Using Backbone Chai Matchers
----------------------------

Assert frequently used backbone constructs using `chai-backbone.js.coffee`

### Triggers

    model.should.trigger("change", with: [model]).when -> model.set attribute: "value"

this can also be chained further:

    model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
    model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"

### Routing

    "page/3".should.route.to myRouter, "openPage", arguments: ["3"]
    "page/3".should.route.to myRouter, "openPage", considering: [conflictingRouter]

### Views

Check in the sinon matchers the statement `call`. This is useful for
testing view event execution

Using Changes Chai matchers
---------------------------

Test for changes using `chai-changes.js.coffee`

Plain change checking:

    expect(-> result).to.change.when -> result += 1
    expect(-> result).to.not.change.when -> somethingElse()

Changes by delta: 'change.by'

    expect(-> view.$('p').length).to.change.by(4).when -> collection.add [{}, {}, {}, {}]

Changes to end result: 'change.to'

    result = ['a']
    expect(-> result).to.change.to(['b']).when -> result = ['b']

Changes from begin result: 'change.from'

    result = ['a']
    expect(-> result).to.change.from(['a']).when -> result = ['b']

Mix and match:

    result = 3
    expect(-> result).to.change.from(3).to(5).by(2).when -> result = 5


Using Sinon Chai Matchers
-------------------------

Matchers have also been added for sinonjs. `chai-sinon.js.coffee`

These are not complete yet, see tests and code for details.

    spy.should.have.been.called.exactly(x).times
    spy.should.have.been.called.before otherSpy
    spy.should.have.been.called.after otherSpy
    spy.should.have.been.called.with "argument1", 2, "argument3"
    spy.should.not.have.been.called
    spy.should.have.been.called

There is also a 'when' filter:

    view.should.call('startAuthentication').when ->
      view.$('a.login').trigger 'click'

This is useful when testing view events from Backbone.js

Using Factories
---------------

Factory (`factories.js.coffee`) support is added to quickly be able to build backbone models or
other objects as you see fit:

    Factory.define 'user', (attributes = {}) ->
      new User attributes

    Factory.create 'user', name: 'Matthijs'

### Traits

you can also use 'traits'.
Traits are flags that are set when the user calls create with the
factory name prefixed with terms separated by dashes.

Like: 'female-admin-user'

This will call the 'user' factory, and provide the terms 'female' and
'admin' as traits for this user

this list is accessible in the factory callback using `this.traits`

There are 2 helper methods to help check if traits are set:

    this.trait('returns', 'one', 'of', 'these', 'values')

and

    this.is('admin') # returns a boolean value

Extended example:

    Factory.define 'user', (attributes = {}) ->
      attributes.gender = @trait('male', 'female') || 'male'

      returningClass = User
      if @is('admin')
        returningClass = AdminUser

      new returningClass attributes

    Factory.create 'user', name: 'Matthijs' # => new User name: 'Matthijs'
    Factory.create 'male-user', name: 'Matthijs' # => new User name: 'Matthijs', gender: 'male'
    Factory.create 'male-admin-user', name: 'Matthijs' # => new AdminUser name: 'Matthijs', gender: 'male'
    Factory.create 'female-user', name: 'Beppie' # => new User name: 'Beppie', gender: 'female'

### Sequences

Sequences are also supported:

    Factory.define 'counter', ->
      {
        amount: @sequence('amount')
        other: @sequence('other')
      }

This does not conflict with similar names in other factory definitions.

You can also yield results:

    Factory.define 'abc', ->
      @sequence (i) -> ['a','b','c'][i]

    # results in:
    Factory.create('abc') => 'a'
    Factory.create('abc') => 'b'

### Sampling

You can sample a value from a list

    Factory.define 'sampler', ->
      @sample 'a', 'b', 'c'

Will randomly return a, b or c every time

Running the tests
=================

You can run the tests by including:

    spec/chai-backbone_spec.js.coffee
    spec/chai-sinon_spec.js.coffee
    spec/chai-changes_spec.js.coffee
    spec/factory_spec.js.coffee


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
