const { Given, When, Then } = require('@cucumber/cucumber')
const Person = require('../../src/shouty')
require('../support/person_parameter')

Given('{person} is located/standing {int} metre(s) from Sean', function (lucy, distance) {

  console.log(lucy);

  // Write code here that turns the phrase above into concrete actions
  console.log(`Lucy is ${distance * 100} centimetres from Sean`);

  return 'pending'
})

When('Sean shouts "free bagels at Sean\'s"', function () {
  // Write code here that turns the phrase above into concrete actions
  return 'pending'
})

Then('Lucy hears Sean’s message', function () {
  // Write code here that turns the phrase above into concrete actions
  return 'pending'
})
