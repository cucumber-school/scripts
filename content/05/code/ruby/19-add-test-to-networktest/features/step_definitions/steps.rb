require 'shouty'

DEFAULT_RANGE = 100

class Whereabouts
  attr_reader :name, :location

  def initialize(name: , location: )
    @name     = name
    @location = location.to_i
  end
end

def define_whereabouts(whereabouts_hash)
  Whereabouts.new(**whereabouts_hash)
end

Before do
  @people = {}
  @network = Shouty::Network.new(DEFAULT_RANGE)
end

Given "the range is {int}" do |range|
  @network = Shouty::Network.new(range)
end

Given "a person named {word}" do |name|
  @people[name] = Shouty::Person.new(@network, 0)
end

Given 'people are located at' do |table|
  table.transpose.symbolic_hashes.each do |whereabouts_hash|
    whereabouts = define_whereabouts(whereabouts_hash)
    @people[whereabouts.name] = Shouty::Person.new(@network, whereabouts.location)
  end
end

When "Sean shouts" do
  @people["Sean"].shout("Hello, world")
end

When "Sean shouts {string}" do |message|
  @people["Sean"].shout(message)
  @message_from_sean = message
end

Then "Lucy should hear Sean's message" do
  expect(@people['Lucy'].messages_heard).to eq [@message_from_sean]
end

Then "Lucy should hear a shout" do
  expect(@people['Lucy'].messages_heard.count).to eq 1
end

Then "Larry should not hear Sean's message" do
  expect(@people['Larry'].messages_heard).not_to include(@message_from_sean)
end

Then "{word} should not hear a shout" do |name|
  expect(@people[name].messages_heard.count).to eq 0
end

Then 'Lucy hears the following messages:' do |expected_messages|
  actual_messages = @people['Lucy'].messages_heard.map { |message| [ message ] }

  expected_messages.diff!(actual_messages)
end
