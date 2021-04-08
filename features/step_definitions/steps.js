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

Given("a person named {word}", function (name) {
  this.people[name] = new Person(this.network, 0)
})

Given("people are located at", function (dataTable) {
  dataTable
    .transpose()
    .hashes()
    .map((person) => {
      this.people[person.name] = new Person(this.network, person.location)
    })
})

Given("Sean has bought {int} credits", function (credits) {
  this.people["Sean"].credits = credits
})

When("Sean shouts", function () {
  this.people["Sean"].shout("Hello, world")
})

When("Sean shouts a message containing the word {string}", function (word) {
  const message = `A message containing the word ${word}`
  this.people["Sean"].shout(message)
  if (!this.messagesShoutedBy["Sean"]) this.messagesShoutedBy["Sean"] = []
  this.messagesShoutedBy["Sean"].push(message)
})

When("Sean shouts {string}", function (message) {
  this.people["Sean"].shout(message)
  if (!this.messagesShoutedBy["Sean"]) this.messagesShoutedBy["Sean"] = []
  this.messagesShoutedBy["Sean"].push(message)
})

When("Sean shouts the following message", function (message) {
  this.people["Sean"].shout(message)
  if (!this.messagesShoutedBy["Sean"]) this.messagesShoutedBy["Sean"] = []
  this.messagesShoutedBy["Sean"].push(message)
})

Then("Lucy should hear Sean's message", function () {
  assertThat(this.messagesShoutedBy["Sean"].length, is(1))
  const message = this.messagesShoutedBy["Sean"][0]
  assertThat(this.people["Lucy"].messagesHeard(), contains(message))
})

Then("Lucy should hear a shout", function () {
  assertThat(this.people["Lucy"].messagesHeard().length, is(1))
})

Then("Larry should not hear Sean's message", function () {
  assertThat(this.messagesShoutedBy["Sean"].length, is(1))
  const message = this.messagesShoutedBy["Sean"][0]
  assertThat(this.people["Larry"].messagesHeard(), not(contains(message)))
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

Then("Lucy hears all Sean's messages", function () {
  assert.deepEqual(
    this.people["Lucy"].messagesHeard(),
    this.messagesShoutedBy["Sean"]
  )
})

Then("Sean should have {int} credits", function (expectedCredits) {
  assertThat(this.people["Sean"].credits, is(expectedCredits))
})
