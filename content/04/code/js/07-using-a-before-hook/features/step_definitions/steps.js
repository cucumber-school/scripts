const { Given, When, Then, Before } = require('cucumber')
const { assertThat, is } = require('hamjest')

const { Person, Network } = require('../../src/shouty')

Before(function () {
  this.network = new Network()
})

Given('Lucy is {int} metres from Sean', function (distance) {
  this.network = new Network()
  this.lucy    = new Person(this.network)

  this.lucy.moveTo(distance)
})

Given('a person named Lucy', function () {
  this.lucy = new Person(this.network)
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
  assertThat(this.lucy.messagesHeard(), is([this.messageFromSean]))
})
