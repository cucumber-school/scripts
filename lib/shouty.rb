module Shouty
  class Person
    attr_reader :messages_heard
    
    def initialize(network)
      @messages_heard = []
      @network        = network
      
      @network.subscribe(self)
    end

    def move_to(distance)
    end

    def shout(message)
      @network.broadcast(message);
    end

    def hear(message)
      @messages_heard << message
    end
  end

  class Network
    def initialize
      @listeners = []
    end

    def subscribe(person)
      @listeners << person
    end

    def broadcast(message)
      @listeners.each do |listener|
        listener.hear(message)
      end
    end
  end
end
