const { Given, When, Then } = require('@cucumber/cucumber')
const { assertThat, is } = require('hamjest')

const { Person, Network } = require('../../src/shouty')

Given('Lucy is {int} metres from Sean', function (distance) {
  this.network = new Network()
  this.lucy    = new Person(this.network)

  this.lucy.moveTo(distance)
})

When('Sean shouts {string}', function (message) {
  sean = new Person(this.network)
  sean.shout(message)
  this.messageFromSean = message
})

Then('Lucy should hear Sean\'s message', function () {
  assertThat(this.lucy.messagesHeard(), is([this.messageFromSean]))
})
