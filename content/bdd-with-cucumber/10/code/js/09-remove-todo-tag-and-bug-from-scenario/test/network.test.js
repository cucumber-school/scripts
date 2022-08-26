const assert = require("assert")
const { assertThat, equalTo } = require("hamjest")
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
    const sean = new Person("Sean", network, shouterLocation)
    const lucy = new Person("Lucy", network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(message, sean)

    assert.strictEqual(lucyStub.hear.getCall(0).args[0], message)
  })

  it("does not broadcast a message to a listener out of range", function () {
    const shouterLocation = 0
    const listenerLocation = 150
    const sean = new Person("Sean", network, shouterLocation)
    const lucy = new Person("Lucy", network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(message, sean)

    assert(lucyStub.hear.notCalled)
  })

  it("does not broadcast a message to a listener out of range negative distance", function () {
    const shouterLocation = 0
    const listenerLocation = -150
    const sean = new Person("Sean", network, shouterLocation)
    const lucy = new Person("Lucy", network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(message, sean)

    assert(lucyStub.hear.notCalled)
  })

  it("does not broadcast a message over 180 characters even if listener is in range", function () {
    const shouterLocation = 0
    const listenerLocation = 90
    const sean = new Person("Sean", network, shouterLocation)
    const lucy = new Person("Lucy", network, listenerLocation)
    const lucyStub = sinon.spy(lucy)

    network.subscribe(lucy)
    network.broadcast(longMessage, sean)

    assert(lucyStub.hear.notCalled)
  })

  it("can change the range", function () {
    const sean = new Person("Sean", network, 0)
    const laura = new Person("Laura", network, 10)

    network.broadcast(message, sean)
    assert.deepEqual(laura.messagesHeard(), [message])

    network.range = 5
    network.broadcast(message, sean)
    assert.deepEqual(laura.messagesHeard(), [message])
  })

  context("credits", () => {
    it("deducts 2 credits for a shout over 180 characters", () => {
      const longMessage = "x".repeat(181)

      const sean = new Person("Sean", network, 0)
      const laura = new Person("Laura", network, 10)

      network.subscribe(laura)
      network.broadcast(longMessage, sean)

      assertThat(sean.credits, equalTo(-2))
    })

    it("deducts 5 credits for mentioning the word 'buy'", () => {
      const message = 'Come buy these awesome croissants'

      const sean  = new Person("Sean", network, 0, 100)
      const laura = new Person("Laura", network, 10)

      network.subscribe(laura)
      network.broadcast(message, sean)

      assertThat(sean.credits, equalTo(95))
    })

    it("deducts 5 credits even if you mention the word 'buy' several times", () => {
      const message = 'Come buy buy buy these awesome croissants'

      const sean  = new Person("Sean", network, 0, 100)
      const laura = new Person("Laura", network, 10)

      network.subscribe(laura)
      network.broadcast(message, sean)

      assertThat(sean.credits, equalTo(95))
    })
  })
})
