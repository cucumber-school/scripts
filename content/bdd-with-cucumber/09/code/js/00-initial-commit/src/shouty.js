class Person {
  constructor(name, network, location) {
    this._name = name
    this._messages = []
    this._credits = 0
    this._network = network
    this._location = location

    this._network.subscribe(this)
  }

  get location() {
    return this._location
  }

  moveTo(location) {
    this._location = location
    return this
  }

  shout(message) {
    this._network.broadcast(message, this)
  }

  hear(message) {
    this._messages.push(message)
  }

  messagesHeard() {
    return this._messages
  }
}

class Network {
  constructor(range) {
    this._listeners = []
    this._range = range
  }

  subscribe(person) {
    this._listeners.push(person)
  }

  broadcast(message, shouter) {
    const shortEnough = message.length <= 180
    this._deductCredits(shortEnough, message, shouter)
    this._listeners.forEach((listener) => {
      const withinRange =
        Math.abs(listener.location - shouter.location) <= this._range
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
  Person,
  Network,
}
