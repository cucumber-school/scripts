package shouty.support;

import io.cucumber.java.ParameterType;
import shouty.Person;

public class ParameterTypes {
    private final ShoutyContext context;

    public ParameterTypes(ShoutyContext context) {
        this.context = context;
    }

    @ParameterType("Lucy|Sean|Larry")
    public Person person(String name) {
        return new Person(name, context.network, 0);
    }
}
