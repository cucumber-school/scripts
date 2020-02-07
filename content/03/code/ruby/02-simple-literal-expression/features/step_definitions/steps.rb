require 'shouty'

Given("Lucy is located 15 metres from Sean") do
  # TODO: automation code to place Lucy and Sean goes here
  pending "matched!"
end

When("Sean shouts {string}") do |message|
  @sean.shout(message)
  @message_from_sean = message
end

Then("Lucy hears Sean's message") do
  expect(@lucy.messages_heard).to eq [@message_from_sean]
end
