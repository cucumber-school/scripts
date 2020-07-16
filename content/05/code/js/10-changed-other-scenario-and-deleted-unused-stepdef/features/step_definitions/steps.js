const { Given, When, Then, Before } = require('cucumber')
const { assertThat, contains, is, not } = require('hamjest')

const { Person, Network } = require('../../src/shouty')

const default_range = 100

Before(function () {
  this.people = {}
  this.network = new Network(default_range)
})

Given('the range is {int}', function (range) {
  this.network = new Network(range)
})

Given('a person named {word}', function (name) {
  this.people[name] = new Person(this.network, 0)
})

Given('people are located at', function (dataTable) {
  dataTable.hashes().map((person) => {
    this.people[person.name] = new Person(this.network, person.location)
  })
})

When('Sean shouts', function () {
  this.people['Sean'].shout('Hello, world')
})

When('Sean shouts {string}', function (message) {
  this.people['Sean'].shout(message)
  this.messageFromSean = message
})

Then('Lucy should hear Sean\'s message', function () {
  assertThat(this.people['Lucy'].messagesHeard(), contains(this.messageFromSean))
})

Then('Lucy should hear a shout', function () {
  assertThat(this.people['Lucy'].messagesHeard().length, is(1))
})

Then('Larry should not hear Sean\'s message', function () {
  assertThat(this.people['Larry'].messagesHeard(), not(contains(this.messageFromSean)))
})

Then('Larry should not hear a shout', function () {
  assertThat(this.people['Larry'].messagesHeard().length, is(0))
})
