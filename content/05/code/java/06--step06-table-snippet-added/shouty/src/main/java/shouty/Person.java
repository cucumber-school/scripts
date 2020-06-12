package shouty;

import java.util.ArrayList;
import java.util.List;

public class Person {
    private final List<String> messagesHeard = new ArrayList<String>();
    private final Network network;
    private final int location;

    public Person(Network network, int location) {
        this.network = network;
        this.location = location;
        network.subscribe(this);
    }

    public List<String> getMessagesHeard() {
        return messagesHeard;
    }

    public void shout(String message) {
        network.broadcast(message, getLocation());
    }

    public void hear(String message) {
        messagesHeard.add(message);
    }

    public int getLocation() {
        return location;
    }
}
