require "spec_helper"
require "./lib/shouty"

RSpec.describe Shouty::Network do
  let(:range)   { 100 }
  let(:network) { Shouty::Network.new(range) }
  let(:message) { "Free bagels!" }

  it "broadcasts a message to a listener within range" do
    sean_location = 0
    lucy = spy(Shouty::Person)
    network.subscribe(lucy)
    network.broadcast(message, sean_location)

    expect(lucy.messages_heard).to have_received(:hear).with(message)
  end

  it "does not broadcast a message to a listener out of range" do
    sean_location = 0
    laura = spy(Shouty::Person, location: 101)
    network.subscribe(laura)
    network.broadcast(message, sean_location)

    expect(laura.messages_heard).not_to have_received(:hear)
  end

  it "does not broadcast a message to a listener out of range negative distance" do
    sally_location = 0
    lionel = spy(Shouty::Person, location: -101)
    network.subscribe(lionel)
    network.broadcast(message, sally_location)

    expect(lionel.messages_heard).not_to have_received(:hear)
  end

  it "does not broadcast a message over 180 characters even if listener is in range" do
    sean_location = 0

    long_message = 'x' * 181

    laura = spy(Shouty::Person, location: 10)
    network.subscribe(laura)
    network.broadcast(long_message, sean_location)

    expect(laura.messages_heard).not_to have_received(:hear).with(long_message)
  end

end
