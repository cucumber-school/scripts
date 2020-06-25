module Shouty
  class Person
    attr_reader :messages_heard, :location

    def initialize(network, location)
      @messages_heard = []
      @network        = network
      @location       = location

      @network.subscribe(self)
    end

    def shout(message)
      @network.broadcast(message, @location)
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

    def broadcast(message, shouter_location)
      @listeners.each do |listener|
        if (listener.location - shouter_location).abs <= @range
          if message.size <= 180
            listener.hear(message)
          end
        end
      end
    end
  end
end
