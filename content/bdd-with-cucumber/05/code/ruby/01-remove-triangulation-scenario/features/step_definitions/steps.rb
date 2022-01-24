require 'shouty'

Before do
  @people = {}
end

Given "the range is {int}" do |range|
  @network = Shouty::Network.new(range)
end

Given "a person named {word} is located at {int}" do |name, location|
  @people[name] = Shouty::Person.new(@network, location)
end

When "Sean shouts {string}" do |message|
  @people["Sean"].shout(message)
  @message_from_sean = message
end

Then "Lucy should hear Sean's message" do
  expect(@people['Lucy'].messages_heard).to eq [@message_from_sean]
end

Then "Larry should not hear Sean's message" do
  expect(@people['Larry'].messages_heard).not_to include(@message_from_sean)
end
