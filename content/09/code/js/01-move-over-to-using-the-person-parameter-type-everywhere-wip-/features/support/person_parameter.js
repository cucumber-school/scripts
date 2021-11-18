const { defineParameterType } = require('@cucumber/cucumber')

const { Person } = require('../../src/shouty')

defineParameterType({
  name: 'person',
  regexp: /Lucy|Sean|Larry/,
  transformer: function(name) { 
    if (!this.people[name]) this.people[name] = new Person(name, this.network, 0)
    return this.people[name]
	}
})