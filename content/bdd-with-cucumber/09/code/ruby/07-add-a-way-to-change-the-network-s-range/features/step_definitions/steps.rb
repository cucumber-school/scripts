DEFAULT_RANGE = 100

Given "the range is {int}" do |range|
  self.network = Shouty::Network.new(range)
end

Given "{person} is located at {int}" do |person, location|
  person.move_to(location)
end

Given('{person} has bought {int} credits') do |person, credits|
  person.credits = credits
end

When "{person} shouts" do |shouter|
  shout from: shouter, message: "Hello, world"
end

When('{person} shouts {string}') do |shouter, message|
  shout from: shouter, message: message
end

When "{person} shouts the following message" do |shouter, message|
  shout from: shouter, message: message
end

When "{person} shouts {int} over-long messages" do |shouter, count|
  count.times do
    base_message = "A message from #{shouter.name} that is 181 characters long "
    message = base_message + "x" * (181 - base_message.size)
    shout from: shouter, message: message
  end
end

When '{person} shouts {int} messages containing the word {string}' do |shouter, count, word|
  count.times do
    message = "A message containing the word #{word}"
    shout from: shouter, message: message
  end
end

Then "{person} should hear a shout" do |listener|
  expect(listener.messages_heard.count).to eq 1
end

Then "{person} should not hear a shout" do |person|
  expect(person.messages_heard.count).to eq 0
end

Then "{person} hears the following messages:" do |listener, expected_messages|
  actual_messages = listener.messages_heard.map { |message| [ message ] }

  expected_messages.diff!(actual_messages)
end

Then("{person} hears all {person}'s messages") do |listener, shouter|
  expect(listener.messages_heard).to match(messages_shouted_by[shouter.name])
end

Then("{person} should have {int} credits") do |shouter, credits|
  expect(shouter.credits).to eql(credits)
end
