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
        Person lucy = new Person(network);
        verify(network).subscribe(lucy);
    }

    @Test
    public void broadcasts_shouts_to_the_network() {
        String message = "Free bagels!";
        Person sean = new Person(network);
        sean.shout(message);
        verify(network).broadcast(message);
    }

    @Test
    public void remembers_messages_heard() {
        String message = "Free bagels!";
        Person lucy = new Person(network);
        lucy.hear(message);
        assertEquals(asList(message), lucy.getMessagesHeard());
    }
}