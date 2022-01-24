require "spec_helper"
require "./lib/shouty"

RSpec.describe Shouty::Network do

  let(:network) { Shouty::Network.new }
  let(:message) { "Free bagels!" }

  it "broadcasts a message to all listeners" do

    lucy = spy(Shouty::Person)
    network.subscribe(lucy)
    network.broadcast(message)

    expect(lucy.messages_heard).to have_received(:hear).with(message)
  end

end
