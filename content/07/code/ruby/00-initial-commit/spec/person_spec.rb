require "spec_helper"
require "./lib/shouty"

RSpec.describe Shouty::Network do

  before(:each) do
    @networkStub = spy(Shouty::Network)
  end

  it "subscribes to the network" do
    lucy = Shouty::Person.new(@networkStub, 0)

    expect(@networkStub).to have_received(:subscribe).with(lucy)
  end

  it "has a location" do
    location = 42
    lucy = Shouty::Person.new(@networkStub, location)

    expect(lucy.location).to eql(location)
  end

  it "broadcasts shouts to the network" do
    location = 0
    message = "Free bagels!"
    sean = Shouty::Person.new(@networkStub, location)

    sean.shout(message)

    expect(@networkStub).to have_received(:broadcast).with(message, location)
  end

  it "remembers messages heard" do
    message = "Free bagels!"
    lucy = Shouty::Person.new(@networkStub, 0)

    lucy.hear(message)

    expect(lucy.messages_heard).to eq([message])
  end

end
