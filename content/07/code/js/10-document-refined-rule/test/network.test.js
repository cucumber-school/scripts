const assert = require("assert")
const sinon = require("sinon")
const { Person, Network } = require("../src/shouty")

describe("Network", function () {
  const range = 100
  const network = new Network(range)
  const message = "Free bagels!"
  const longMessage = "x".repeat(181)

  it("broadcasts a message to a listener within range", function () {
    const shouterLocation = 0
    const listenerLocation = 90
    const sean = new Person(network, shouterLocation)
    const lucy = new Person(network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(message, sean)

    assert.strictEqual(lucyStub.hear.getCall(0).args[0], message)
  })

  it("does not broadcast a message to a listener out of range", function () {
    const shouterLocation = 0
    const listenerLocation = 150
    const sean = new Person(network, shouterLocation)
    const lucy = new Person(network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(message, sean)

    assert(lucyStub.hear.notCalled)
  })

  it("does not broadcast a message to a listener out of range negative distance", function () {
    const shouterLocation = 0
    const listenerLocation = -150
    const sean = new Person(network, shouterLocation)
    const lucy = new Person(network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(message, sean)

    assert(lucyStub.hear.notCalled)
  })

  it("does not broadcast a message over 180 characters even if listener is in range", function () {
    const shouterLocation = 0
    const listenerLocation = 90
    const sean = new Person(network, shouterLocation)
    const lucy = new Person(network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(longMessage, sean)

    assert(lucyStub.hear.notCalled)
  })
})
