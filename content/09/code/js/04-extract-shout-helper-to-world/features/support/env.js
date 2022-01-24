const { setWorldConstructor } = require("@cucumber/cucumber")

class ShoutyWorld {
  shout({ from: shouter, message }) {
    shouter.shout(message)
    if (!this.messagesShoutedBy[shouter.name])
      this.messagesShoutedBy[shouter.name] = []
    this.messagesShoutedBy[shouter.name].push(message)
  }
}

setWorldConstructor(ShoutyWorld)
