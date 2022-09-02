package shouty.support;

import shouty.Network;
import shouty.Person;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ShoutyWorld{
    private static final int DEFAULT_RANGE = 0;
    public Network network = new Network(DEFAULT_RANGE);
    public Map<String, Person> people = new HashMap<String, Person>();
    public Map<String, List<String>> messagesShoutedBy = new HashMap<String, List<String>>();

    public void shout(Person person, String message) {
        person.shout(message);
        List<String> messages = messagesShoutedBy.get(person.getName());
        if (messages == null) {
            messages = new ArrayList<String>();
            messagesShoutedBy.put(person.getName(), messages);
        }
        messages.add(message);
    }
}
