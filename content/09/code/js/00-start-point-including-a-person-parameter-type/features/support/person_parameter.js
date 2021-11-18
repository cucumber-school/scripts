const { defineParameterType } = require('@cucumber/cucumber')

const { Person } = require('../../src/shouty')

defineParameterType({
  name: 'person',
  regexp: /Lucy|Sean|Larry/,
  transformer: function(name) { 
		return new Person(name, this.network, 0)
	}
})