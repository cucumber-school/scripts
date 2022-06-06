package shouty.support;

import io.cucumber.java.ParameterType;
import shouty.Person;

public class ParameterTypes {
    private final ShoutyWorld world;

    public ParameterTypes(ShoutyWorld world) {
        this.world = world;
    }

    @ParameterType("Lucy|Sean|Larry")
    public Person person(String name) {
        return new Person(name, world.network, 0);
    }
}
