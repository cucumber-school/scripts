require "spec_helper"
require "./lib/shouty"

RSpec.describe Shouty::Network do
  let(:range)   { 100 }
  let(:network) { Shouty::Network.new(range) }
  let(:message) { "Free bagels!" }
  let(:sean)    { spy(Shouty::Person, location: 0, credits: 0) }

  it "broadcasts a message to a listener within range" do
    lucy = spy(Shouty::Person, location: 0)
    network.subscribe(lucy)
    network.broadcast(message, sean)

    expect(lucy.messages_heard).to have_received(:hear).with(message)
  end

  it "does not broadcast a message to a listener out of range" do
    laura = spy(Shouty::Person, location: 101)
    network.subscribe(laura)
    network.broadcast(message, sean)

    expect(laura.messages_heard).not_to have_received(:hear)
  end

  it "does not broadcast a message to a listener out of range negative distance" do
    lionel = spy(Shouty::Person, location: -101)
    network.subscribe(lionel)
    network.broadcast(message, sean)

    expect(lionel.messages_heard).not_to have_received(:hear)
  end

  it "does not broadcast a message over 180 characters even if listener is in range" do
    long_message = 'x' * 181

    sean  = Shouty::Person.new("Sean", network, 0)
    laura = Shouty::Person.new("Laura", network, 10)

    network.subscribe(laura)
    network.broadcast(long_message, sean)

    expect(laura.messages_heard).not_to include(long_message)
  end

  context "credits" do
    it "deducts 2 credits for a shout over 180 characters" do
      long_message = 'x' * 181

      sean  = Shouty::Person.new("Sean", network, 0)
      laura = Shouty::Person.new("Laura", network, 10)

      network.subscribe(laura)
      network.broadcast(long_message, sean)

      expect(sean.credits).to eq(-2)
    end
  end
end
