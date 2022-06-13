package shouty.support;

import shouty.Network;
import shouty.Person;

import java.util.HashMap;
import java.util.Map;

public class ShoutyWorld{
    private static final int DEFAULT_RANGE = 0;
    public Network network = new Network(DEFAULT_RANGE);
    public Map<String, Person> people = new HashMap<String, Person>();
}
