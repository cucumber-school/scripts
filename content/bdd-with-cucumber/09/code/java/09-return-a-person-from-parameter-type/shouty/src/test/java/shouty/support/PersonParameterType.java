package shouty.support;

import io.cucumber.java.ParameterType;
import shouty.Person;

public class PersonParameterType {
    @ParameterType("Lucy|Sean|Larry")
    public Person person(String name) {
        return new Person(name, world.network, 0);
    }
}

