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