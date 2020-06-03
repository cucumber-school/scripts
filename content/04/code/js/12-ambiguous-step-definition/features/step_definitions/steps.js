const { Given, When, Then, Before } = require('cucumber')
const { assertThat, is } = require('hamjest')

const { Person, Network } = require('../../src/shouty')

Before(function () {
  this.network = new Network()
  this.people = {}
})

Given('a person named {word}', function (name) {
  this.people[name] = new Person(this.network)
})

Given('a person named Sean', function () {
  this.sean = new Person(this.network)
})

When('Sean shouts {string}', function (message) {
  sean = new Person(this.network)
  sean.shout(message)
  this.messageFromSean = message
})

Then('Lucy should hear Sean\'s message', function () {
  assertThat(this.people['Lucy'].messagesHeard(), is([this.messageFromSean]))
})
