package shouty;

import java.util.ArrayList;
import java.util.List;

public class Person {
    private Integer location;

    public void setLocation(Integer location) {
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
