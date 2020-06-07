require 'shouty'

Given("Lucy is {int} metres from Sean") do |distance|
  @network = Shouty::Network.new
  @lucy    = Shouty::Person.new(@network)
  @sean    = Shouty::Person.new(@network)
  
  @lucy.move_to(distance)
end

When("Sean shouts {string}") do |message|
  @sean.shout(message)
  @message_from_sean = message
end

Then("Lucy should hear Sean's message") do
  expect(@lucy.messages_heard).to eq [@message_from_sean]
end
