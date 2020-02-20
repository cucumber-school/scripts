require 'shouty'

Given("{person} is located/standing {int} metre(s) from Sean") do |person, distance|
  person.move_to(distance)
  @lucy = person
end

When("Sean shouts {string}") do |message|
  sean = Shouty::Person.new('Sean')
  sean.shout(message)
  @message_from_sean = message
end

Then("Lucy hears Sean's message") do
  expect(@lucy.messages_heard).to eq [@message_from_sean]
end
