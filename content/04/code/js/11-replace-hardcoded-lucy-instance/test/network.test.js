const sinon = require('sinon')
const {Network} = require('../src/shouty')

describe('Network', () => {
  it('broadcasts a message to all listeners', () => {
    const network = new Network()
    const message = "Free bagels!"
    const lucy = { hear(message) {} }
    const lucyMock = sinon.mock(lucy)
    lucyMock.expects('hear').once().withArgs(message)
    network.subscribe(lucy)
    network.broadcast(message)
    lucyMock.verify()
  })
})
