const { Given, When, Then, Before } = require("@cucumber/cucumber")
const { assertThat, contains, is, not, containsInAnyOrder } = require("hamjest")
const assert = require("assert")

const { Network } = require("../../src/shouty")

const default_range = 100

Before(function () {
  this.messagesShoutedBy = {}
  this.network = new Network(default_range)
})

Given("the range is {int}", function (range) {
  this.network = new Network(range)
})

Given('{person} is located at {int}', function (person, location) {
  person.moveTo(location)
})

Given("{person} has bought {int} credits", function (sean, credits) {
  sean.credits = credits
})

When("{person} shouts", function (shouter) {
  shouter.shout("Hello, world")
})

When(
  "{person} shouts {int} messages containing the word {string}",
  function (shouter, count, word) {
    for (let i = 0; i < count; i++) {
      const message = `A message containing the word ${word}`
      shouter.shout(message)
      if (!this.messagesShoutedBy[shouter.name]) this.messagesShoutedBy[shouter.name] = []
      this.messagesShoutedBy[shouter.name].push(message)
    }
  }
)

When("{person} shouts {int} over-long messages", function (shouter, count) {
  for (let i = 0; i < count; i++) {
    const baseMessage = `A message from ${shouter.name} that is 181 characters long `
    const message = baseMessage + "x".repeat(181 - baseMessage.length)
    shouter.shout(message)
    if (!this.messagesShoutedBy[shouter.name]) this.messagesShoutedBy[shouter.name] = []
    this.messagesShoutedBy[shouter.name].push(message)
  }
})

When("{person} shouts {string}", function (shouter, message) {
  shouter.shout(message)
  if (!this.messagesShoutedBy[shouter.name]) this.messagesShoutedBy[shouter.name] = []
  this.messagesShoutedBy[shouter.name].push(message)
})

When("{person} shouts the following message", function (shouter, message) {
  shouter.shout(message)
  if (!this.messagesShoutedBy[shouter.name]) this.messagesShoutedBy[shouter.name] = []
  this.messagesShoutedBy[shouter.name].push(message)
})

Then("{person} should hear a shout", function (listener) {
  assertThat(listener.messagesHeard().length, is(1))
})

Then("{person} should not hear a shout", function (listener) {
  assertThat(listener.messagesHeard().length, is(0))
})

Then("{person} hears the following messages:", function (listener, expectedMessages) {
  let actualMessages = listener
    .messagesHeard()
    .map((message) => [message])

  assert.deepEqual(actualMessages, expectedMessages.raw())
})

Then("{person} hears all {person}'s messages", function (listener, shouter) {
  assert.deepEqual(
    listener.messagesHeard(),
    this.messagesShoutedBy[shouter.name]
  )
})

Then("{person} should have {int} credits", function (person, expectedCredits) {
  assertThat(person.credits, is(expectedCredits))
})
