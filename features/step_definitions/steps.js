const { Given, When, Then } = require("@cucumber/cucumber")
const { assertThat, is, equalTo } = require("hamjest")

Given("the range is {int}", function (range) {
  this.network.range = range
})

Given("{person} is located at {int}", function (person, location) {
  person.moveTo(location)
})

Given("{person} has bought {int} credits", function (person, credits) {
  person.credits = credits
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
