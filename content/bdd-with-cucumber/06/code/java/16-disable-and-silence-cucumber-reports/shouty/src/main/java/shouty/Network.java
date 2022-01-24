package shouty;

import java.util.ArrayList;
import java.util.List;

public class Network {
    private final List<Person> listeners = new ArrayList<Person>();
    private final int range;

    public Network(int range) {
        this.range = range;
    }

    public void subscribe(Person person) {
        listeners.add(person);
    }

    public void broadcast(String message, int shouterLocation) {
        for (Person listener : listeners) {
            boolean withinRange = (Math.abs(listener.getLocation() - shouterLocation) <= range);
            boolean shortEnough = (message.length() <= 180);
            if (withinRange && shortEnough) {
                listener.hear(message);
            }
        }
    }
}