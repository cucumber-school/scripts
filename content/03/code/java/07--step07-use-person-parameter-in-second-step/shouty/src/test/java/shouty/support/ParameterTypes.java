package shouty.support;

import io.cucumber.java.ParameterType;
import shouty.Person;

public class ParameterTypes {

    @ParameterType("Lucy|Sean")
    public Person person(String name) {
        return new Person(name);
    }
}
