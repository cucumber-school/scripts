module Shouty
  class Person
    attr_reader :messages_heard, :location
    attr_accessor :credits

    def initialize(network, location)
      @messages_heard = []
      @network        = network
      @location       = location
      @credits        = 0

      @network.subscribe(self)
    end

    def shout(message)
      @network.broadcast(message, self)
    end

    def hear(message)
      @messages_heard << message
    end
  end

  class Network
    def initialize(range)
      @range     = range
      @listeners = []
    end

    def subscribe(person)
      @listeners << person
    end

    def broadcast(message, shouter)
      short_enough = message.size <= 180
      deduct_credits(short_enough, message, shouter)
      @listeners.each do |listener|
        within_range = (listener.location - shouter.location).abs <= @range

        if within_range && (short_enough || shouter.credits >= 0)
          listener.hear(message)
        end
      end
    end

    def deduct_credits(short_enough, message, shouter)
      shouter.credits -= 2 unless short_enough
      shouter.credits -= (message.scan(/buy/i) || []).size * 5
    end
  end
end
