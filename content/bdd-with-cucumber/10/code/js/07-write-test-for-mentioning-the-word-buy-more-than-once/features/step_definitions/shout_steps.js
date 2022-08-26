const { When } = require("@cucumber/cucumber")

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
