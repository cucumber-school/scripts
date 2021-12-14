package shouty;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.Before;
import io.cucumber.java.DataTableType;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.*;

import static org.hamcrest.CoreMatchers.hasItems;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {

    private static final int DEFAULT_RANGE = 100;
    private Network network = new Network(DEFAULT_RANGE);
    private Map<String, Person> people;
    private Map<String, List<String>> messagesShoutedBy;


    static class Whereabouts {
        public String name;
        public Integer location;

        public Whereabouts(String name, int location) {
            this.name = name;
            this.location = location;
        }
    }

    @DataTableType
    public Whereabouts defineWhereabouts(Map<String, String> entry) {
        return new Whereabouts(entry.get("name"), Integer.parseInt(entry.get("location")));
    }

    @Before
    public void setup() {
        people = new HashMap<String, Person>();
        messagesShoutedBy = new HashMap<String, List<String>>();
    }

    @Given("the range is {int}")
    public void the_range_is(int range) throws Throwable {
        network = new Network(range);
    }

    @Given("{word} is located at {int}")
    public void person_is_located_at(String name, Integer location) {
        Person person = new Person(name, network, location);
        people.put(person.getName(), person);
    }

    @Given("{word} has bought {int} credits")
    public void person_has_bought_credits(String name, int credits) {
        people.get(name).setCredits(credits);
    }

    @When("{word} shouts")
    public void person_shouts(String name) throws Throwable {
        Person person = people.get(name);
        shout(person, "Hello, world");
    }

    @When("{word} shouts {string}")
    public void person_shouts_message(String name, String message) throws Throwable {
        Person person = people.get(name);
        shout(person, message);
    }

    @When("{word} shouts {int} messages containing the word {string}")
    public void person_shouts_messages_containing_the_word(String name, int count, String word) throws Throwable {
        Person person = people.get(name);
        String message = "a message containing the word " + word;
        for (int i = 0; i < count; i++) {
            shout(person, message);
        }
    }

    @When("{word} shouts the following message")
    public void person_shouts_the_following_message(String name, String message) throws Throwable {
        Person person = people.get(name);
        shout(person, message);
    }

    @When("{word} shouts {int} over-long messages")
    public void person_shouts_some_over_long_messages(String name, int count) throws Throwable {
        Person person = people.get(name);
        String baseMessage = "A message from Sean that is 181 characters long ";
        String padding = "x";
        String overlongMessage = baseMessage + padding.repeat(181 - baseMessage.length());

        for (int i = 0; i < count; i++) {
            shout(person, overlongMessage);
        }
    }

    private void shout(Person person, String message) {
        person.shout(message);
        List<String> messages = messagesShoutedBy.get(person.getName());
        if (messages == null) {
            messages = new ArrayList<String>();
            messagesShoutedBy.put(person.getName(), messages);
        }
        messages.add(message);
    }

    @Then("{word} should hear Sean's message")
    public void person_hears_Sean_s_message(String name) throws Throwable {
        List<String> messages = messagesShoutedBy.get("Sean");
        assertEquals(messages, people.get(name).getMessagesHeard());
    }

    @Then("{word} should not hear a shout")
    public void person_should_not_hear_a_shout(String name) throws Throwable {
        assertEquals(0, people.get(name).getMessagesHeard().size());
    }

    @Then("{word} hears the following messages:")
    public void person_hears_the_following_messages(String name, DataTable expectedMessages) {
        List<List<String>> actualMessages = new ArrayList<List<String>>();
        List<String> heard = people.get(name).getMessagesHeard();
        for (String message : heard) {
            actualMessages.add(Collections.singletonList(message));
        }
        expectedMessages.diff(DataTable.create(actualMessages));
    }

    @Then("{word} hears all Sean's messages")
    public void person_hears_all_Sean_s_messages(String name) throws Throwable {
        List<String> heardByLucy = people.get(name).getMessagesHeard();
        List<String> messagesFromSean = messagesShoutedBy.get("Sean");

        // Hamcrest's hasItems matcher wants an Array, not a List.
        String[] messagesFromSeanArray = messagesFromSean.toArray(new String[messagesFromSean.size()]);
        assertThat(heardByLucy, hasItems(messagesFromSeanArray));
    }

    @Then("{word} should have {int} credits")
    public void person_should_have_credits(String name, int expectedCredits) {
        assertEquals(expectedCredits, people.get(name).getCredits());
    }
}
