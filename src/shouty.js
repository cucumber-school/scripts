class Person {
  constructor(network) {
    this.messages = []
    this.network      = network

    this.network.subscribe(this)
  }
  
  shout(message) {
    this.network.broadcast(message)
  }

  hear(message) {
    this.messages.push(message)
  }

  messagesHeard() {
    return this.messages
  }
}

class Network {
  constructor() {
    this.listeners = []
  }

  subscribe(person) {
    this.listeners.push(person)
  }

  broadcast(message) {
    this.listeners.forEach(listener => { listener.hear(message) })
  }
}

module.exports = {
  Person  : Person,
  Network : Network
}
