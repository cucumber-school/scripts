Given "the range is {int}" do |range|
  network.range = range
end

Given "{person} is located at {int}" do |person, location|
  person.move_to(location)
end

Given('{person} has bought {int} credits') do |person, credits|
  person.credits = credits
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
