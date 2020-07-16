// var assert = require('assert');
// describe('Array', function () {
//   describe('#indexOf()', function () {
//     it('should return -1 when the value is not present', function () {
//       assert.equal([1, 2, 3].indexOf(4), -1);
//     });
//   });
// });

const { assert } = require('assert')

const { Person, Network } = require('../src/shouty')

describe('Network', function () {
  const range   = 100
  const network = new Network(range)
  const message = "Free bagels!"

  it('broadcasts a message to a listener within range', function () {
    // let sean_location = 0
    // let lucy = new Person

    // network.subscribe(lucy)
    // network.broadcast(message, sean_location)

    //  assert.equal([1, 2, 3].indexOf(4), -1);
    // expect(lucy.messages_heard).to have_received(:hear).with(message)
  })

  it('does not broadcast a message to a listener out of range', function () {
    // sean_location = 0
    // laura = spy(Shouty::Person, location: 101)
    // network.subscribe(laura)
    // network.broadcast(message, sean_location)

    // expect(laura.messages_heard).not_to have_received(:hear).with(message)
  })

  it('does not broadcast a message to a listener out of range negative distance', function () {
    // sally_location = 101
    // lionel = spy(Shouty::Person, location: 0)
    // network.subscribe(lionel)
    // network.broadcast(message, sally_location)

    // expect(lionel.messages_heard).not_to have_received(:hear).with(message)
  })

  it('does not broadcast a message over 180 characters even if listener is in range', function () {

  })

})
