module ShoutyWorld
  def shout(from:, message:)
    shouter = from
    shouter.shout(message)
    messages_shouted_by[shouter.name] << message
  end

  def messages_shouted_by
    @messages_shouted_by ||= Hash.new([])
  end

  def network
    @network ||= Shouty::Network.new(DEFAULT_RANGE)
  end

  attr_writer :network
end

World(ShoutyWorld)
