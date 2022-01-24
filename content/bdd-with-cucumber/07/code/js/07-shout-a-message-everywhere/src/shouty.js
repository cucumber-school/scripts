class Person {
  constructor(network, location) {
    this.messages = []
    this.credits = 0
    this.network = network
    this.location = location

    this.network.subscribe(this)
  }

  shout(message) {
    this.network.broadcast(message, this)
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
    this.range = range
  }

  subscribe(person) {
    this.listeners.push(person)
  }

  broadcast(message, shouter) {
    const shortEnough = message.length <= 180
    this._deductCredits(shortEnough, message, shouter)
    this.listeners.forEach((listener) => {
      const withinRange =
        Math.abs(listener.location - shouter.location) <= this.range
      if (withinRange && (shortEnough || shouter.credits >= 0)) {
        listener.hear(message)
      }
    })
  }

  _deductCredits(shortEnough, message, shouter) {
    if (!shortEnough) shouter.credits -= 2
    shouter.credits -= (message.match(/buy/gi) || []).length * 5
  }
}

module.exports = {
  Person: Person,
  Network: Network,
}
