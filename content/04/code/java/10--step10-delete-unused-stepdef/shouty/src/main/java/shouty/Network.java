package shouty;

import java.util.ArrayList;
import java.util.List;

public class Network {
    private final List<Person> listeners = new ArrayList<Person>();

    public void subscribe(Person person) {
        listeners.add(person);
    }

    public void broadcast(String message) {
        for (Person listener : listeners) {
            listener.hear(message);
        }
    }
}
