require 'shouty'

Before do
  @network = Shouty::Network.new
  @people  = {}
end

Given('a person named {word}') do |name|
  @people[name] = Shouty::Person.new(@network)
end

When("Sean shouts {string}") do |message|
  @people['Sean'].shout(message)
  @message_from_sean = message
end

Then("Lucy should hear Sean's message") do
  expect(@people['Lucy'].messages_heard).to eq [@message_from_sean]
end
