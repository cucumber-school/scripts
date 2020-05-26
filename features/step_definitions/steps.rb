require 'shouty'

Before do
  @network = Shouty::Network.new
  @people  = {}
end

Given('a person named Lucy') do
  @people['Lucy'] = Shouty::Person.new(@network)
end

Given('a person named Sean') do
  @sean = Shouty::Person.new(@network)
end

When("Sean shouts {string}") do |message|
  @sean.shout(message)
  @message_from_sean = message
end

Then("Lucy should hear Sean's message") do
  expect(@people['Lucy'].messages_heard).to eq [@message_from_sean]
end
