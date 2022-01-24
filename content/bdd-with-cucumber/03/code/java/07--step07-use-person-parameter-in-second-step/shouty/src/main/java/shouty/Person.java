package shouty;

import java.util.ArrayList;
import java.util.List;

public class Person {
    private Integer location;
    private String name;

    public Person(String name_) { name = name_; }

    public void moveTo(Integer location) {
        this.location = location;
    }

    public void shout(String message) {

    }

    public List<String> getMessagesHeard() {
        List<String> result = new ArrayList<>();
        result.add("free bagels at Sean's");
        return result;
    }
}
