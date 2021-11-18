const { Given, When, Then, Before } = require("@cucumber/cucumber")
const { assertThat, contains, is, not, containsInAnyOrder } = require("hamjest")
const assert = require("assert")

const { Person, Network } = require("../../src/shouty")

const default_range = 100

Before(function () {
  this.people = {}
  this.messagesShoutedBy = {}
  this.network = new Network(default_range)
})

Given("the range is {int}", function (range) {
  this.network = new Network(range)
})

Given('{person} is located at {int}', function (person, location) {
  this.people[person.name] = person.moveTo(location)
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

When("{person} shouts a message", function (shouter) {
  const message = `A message from ${shouter.name}`
  shouter.shout(message)
  if (!this.messagesShoutedBy[shouter.name]) this.messagesShoutedBy[shouter.name] = []
  this.messagesShoutedBy[shouter.name].push(message)
})

When("{person} shouts a long message", function (shouter) {
  const message = [`A message from ${shouter.name}`, "that spans multiple lines"].join(
    "\n"
  )
  shouter.shout(message)
  if (!this.messagesShoutedBy[shouter.name]) this.messagesShoutedBy[shouter.name] = []
  this.messagesShoutedBy[shouter.name].push(message)
})

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

Then("Lucy should hear a shout", function () {
  assertThat(this.people["Lucy"].messagesHeard().length, is(1))
})

Then("{word} should not hear a shout", function (name) {
  assertThat(this.people[name].messagesHeard().length, is(0))
})

Then("Lucy hears the following messages:", function (expectedMessages) {
  let actualMessages = this.people["Lucy"]
    .messagesHeard()
    .map((message) => [message])

  assert.deepEqual(actualMessages, expectedMessages.raw())
})

Then("Lucy hears all {person}'s messages", function (shouter) {
  assert.deepEqual(
    this.people["Lucy"].messagesHeard(),
    this.messagesShoutedBy[shouter.name]
  )
})

Then("Sean should have {int} credits", function (expectedCredits) {
  assertThat(this.people["Sean"].credits, is(expectedCredits))
})
