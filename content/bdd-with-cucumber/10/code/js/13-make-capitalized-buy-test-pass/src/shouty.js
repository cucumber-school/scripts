class Person {
  constructor(name, network, location, credits = 0) {
    this._name = name
    this._messages = []
    this._credits = credits
    this._network = network
    this._location = location

    this._network.subscribe(this)
  }

  get location() {
    return this._location
  }

  set credits(newCredits) {
    this._credits = newCredits
  }

  get credits() {
    return this._credits
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

  set range(newRange) {
    this._range = newRange
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
    shouter.credits -= (message.match(/buy/i) || []).length * 5
  }
}

module.exports = {
  Person,
  Network,
}
