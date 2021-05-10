require 'shouty'

DEFAULT_RANGE = 100

Before do
  @people = {}
  @network = Shouty::Network.new(DEFAULT_RANGE)
  @messages_shouted_by = Hash.new([])
end

Given "the range is {int}" do |range|
  @network = Shouty::Network.new(range)
end

Given "a person named {word}" do |name|
  @people[name] = Shouty::Person.new(@network, 0)
end

Given "people are located at" do |table|
  table.transpose.symbolic_hashes.each do |name: , location: |
    @people[name] = Shouty::Person.new(@network, location.to_i)
  end
end

Given('Sean has bought {int} credits') do |credits|
  @people["Sean"].credits = credits
end

When "Sean shouts" do
  @people["Sean"].shout("Hello, world")
  @messages_shouted_by["Sean"] << "Hello, world"
end

When "Sean shouts {string}" do |message|
  @people["Sean"].shout(message)
  @messages_shouted_by["Sean"] << message
end

When 'Sean shouts the following message' do |message|
  @people["Sean"].shout(message)
  @messages_shouted_by["Sean"] << message
end

When "Sean shouts a message" do
  message = "A message from Sean"
  @people["Sean"].shout(message)
  @messages_shouted_by["Sean"] << message
end

When "Sean shouts a long message" do
  message = ["A message from Sean", "that spans multiple lines"].join("\n")
  @people["Sean"].shout(message)
  @messages_shouted_by["Sean"] << message
end

When 'Sean shouts a message containing the word {string}' do |word|
  message = "A message containing the word #{word}"
  @people["Sean"].shout(message)
  @messages_shouted_by["Sean"] << message
end

Then "Lucy should hear Sean's message" do
  expect(@people['Lucy'].messages_heard).to eq [@messages_shouted_by["Sean"][0]]
end

Then "Lucy should hear a shout" do
  expect(@people['Lucy'].messages_heard.count).to eq 1
end

Then "Larry should not hear Sean's message" do
  expect(@people['Larry'].messages_heard).not_to include(@messages_shouted_by["Sean"][0])
end

Then "{word} should not hear a shout" do |name|
  expect(@people[name].messages_heard.count).to eq 0
end

Then "Lucy hears the following messages:" do |expected_messages|
  actual_messages = @people['Lucy'].messages_heard.map { |message| [ message ] }

  expected_messages.diff!(actual_messages)
end

Then("Lucy hears all Sean's messages") do
  expect(@people["Lucy"].messages_heard).to match(@messages_shouted_by["Sean"])
end

Then("Sean should have {int} credits") do |credits|
  expect(@people["Sean"].credits).to eql(credits)
end
