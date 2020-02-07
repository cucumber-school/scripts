require 'shouty'

Given("{person} is located/standing {int} metre(s) from {person}") do |lucy, distance, sean|
  @lucy = lucy
  @sean = sean
  lucy.move_to(distance)
end

When("Sean shouts {string}") do |message|
  @sean.shout(message)
  @message_from_sean = message
end

Then("Lucy hears Sean's message") do
  expect(@lucy.messages_heard).to eq [@message_from_sean]
end

Then("Lucy does not hear Sean's message") do
  expect(@lucy.messages_heard).not.to include [@message_from_sean]
end
