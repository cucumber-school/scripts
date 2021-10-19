module ShoutyWorld
  def sean_shout(message)
    message = "A message containing the word #{message}"
    @people["Sean"].shout(message)
    @messages_shouted_by["Sean"] << message
  end
end

World(ShoutyWorld)
