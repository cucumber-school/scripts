const { defineParameterType } = require('cucumber')

const Person = require('../../src/shouty')

defineParameterType({
  name: 'person',
  regexp: /Lucy|Sean/,
  transformer: s => new Person()
})
