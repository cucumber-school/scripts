class Person {
  constructor(network, location) {
    this.messages = []
    this.network  = network
    this.location = location


    this.network.subscribe(this)
  }

  shout(message) {
    this.network.broadcast(message, this.location)
  }

  hear(message) {
    this.messages.push(message)
  }

  messagesHeard() {
    return this.messages
  }
}

class Network {
  constructor(range) {
    this.listeners = []
    this.range     = range
  }

  subscribe(person) {
    this.listeners.push(person)
  }

  broadcast(message, shouter_location) {
    this.listeners.forEach(listener => {
      if( Math.abs(listener.location - shouter_location) <= this.range)
        listener.hear(message)
    })
  }
}

module.exports = {
  Person  : Person,
  Network : Network
}
