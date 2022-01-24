const { Given, When, Then } = require("@cucumber/cucumber")
const { assertThat, is, equalTo } = require("hamjest")

const { Network } = require("../../src/shouty")

Given("the range is {int}", function (range) {
  this.network = new Network(range)
})

Given("{person} is located at {int}", function (person, location) {
  person.moveTo(location)
})

Given("{person} has bought {int} credits", function (person, credits) {
  person.credits = credits
})

When("{person} shouts", function (shouter) {
  const message = "Hello, world"
  this.shout({ from: shouter, message })
})

When(
  "{person} shouts {int} messages containing the word {string}",
  function (shouter, count, word) {
    for (let i = 0; i < count; i++) {
      const message = `A message containing the word ${word}`
      this.shout({ from: shouter, message })
    }
  }
)

When("{person} shouts {int} over-long messages", function (shouter, count) {
  for (let i = 0; i < count; i++) {
    const baseMessage = `A message from ${shouter.name} that is 181 characters long `
    const message = baseMessage + "x".repeat(181 - baseMessage.length)
    this.shout({ from: shouter, message })
  }
})

When("{person} shouts {string}", function (shouter, message) {
  this.shout({ from: shouter, message })
})

When("{person} shouts the following message", function (shouter, message) {
  this.shout({ from: shouter, message })
})

Then("{person} should not hear a shout", function (listener) {
  assertThat(listener.messagesHeard().length, is(0))
})

Then(
  "{person} hears the following messages:",
  function (listener, expectedMessages) {
    let actualMessages = listener.messagesHeard().map((message) => [message])
    assertThat(actualMessages, equalTo(expectedMessages.raw()))
  }
)

Then("{person} hears all {person}'s messages", function (listener, shouter) {
  assertThat(
    listener.messagesHeard(),
    equalTo(this.messagesShoutedBy[shouter.name])
  )
})

Then("{person} should hear {person}'s message", function (listener, shouter) {
  assertThat(
    listener.messagesHeard()[0],
    equalTo(this.messagesShoutedBy[shouter.name][0])
  )
})

Then("{person} should have {int} credits", function (person, expectedCredits) {
  assertThat(person.credits, is(expectedCredits))
})
