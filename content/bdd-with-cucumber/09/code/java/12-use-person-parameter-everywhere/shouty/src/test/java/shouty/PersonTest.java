package shouty;

import org.junit.Test;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class PersonTest {
    private final Network network = mock(Network.class);

    @Test
    public void it_subscribes_to_the_network() {
        Person person = new Person("A Person:", network, 100);
        verify(network).subscribe(person);
    }

    @Test
    public void it_has_a_location() {
        Person person = new Person("A Person", network, 100);
        assertEquals(100, person.getLocation());
    }

    @Test
    public void broadcasts_shouts_to_the_network() {
        String message = "Free bagels!";
        Person sean = new Person("Sean", network, 0);
        sean.shout(message);
        verify(network).broadcast(message, sean);
    }

    @Test
    public void remembers_messages_heard() {
        String message = "Free bagels!";
        Person lucy = new Person("Lucy", network, 100);
        lucy.hear(message);
        assertEquals(asList(message), lucy.getMessagesHeard());
    }

    @Test
    public void can_be_moved_to_new_location() {
        Person lucy = new Person("Lucy", network, 0);
        assertEquals(lucy.moveTo(100).getLocation(), 100);
    }
}
