package shouty;

import java.util.ArrayList;
import java.util.List;

public class Person {
    private final List<String> messagesHeard = new ArrayList<String>();
    private final Network network;
    private final String name;
    private int location;
    public int credits;

    public Person(String name, Network network, int location, int credits) {
        this.name = name;
        this.network = network;
        this.location = location;
        this.credits = credits;
        network.subscribe(this);
    }

    public Person(String name, Network network, int location) {
        this.name = name;
        this.network = network;
        this.location = location;
        this.credits = 0;
        network.subscribe(this);
    }

    public List<String> getMessagesHeard() {
        return messagesHeard;
    }

    public void shout(String message) {
        network.broadcast(message, this);
    }

    public void hear(String message) {
        messagesHeard.add(message);
    }

    public int getLocation() {
        return location;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public Person moveTo(int newLocation) {
        this.location = newLocation;
        return this;
    }

    public int getCredits() {
        return credits;
    }

    public String getName() { return name; }
}
