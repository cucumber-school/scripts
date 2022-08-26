const { defineParameterType } = require('@cucumber/cucumber')

const { Person } = require('../../src/shouty')

defineParameterType({
  name: 'person',
  regexp: /Lucy|Sean|Larry/,
  transformer: function(name) { 
    this.people = this.people || {}
    return this.people[name] = this.people[name] || new Person(name, this.network, 0)
	}
})