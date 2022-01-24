module ShoutyWorld
  def shout(from:, message:)
    shouter = from
    shouter.shout(message)
    @messages_shouted_by[shouter.name] << message
  end
end

World(ShoutyWorld)
