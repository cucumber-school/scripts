package shouty;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.DataTableType;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import shouty.support.ShoutyWorld;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.hamcrest.CoreMatchers.hasItems;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {

    private ShoutyWorld world;

    public StepDefinitions(ShoutyWorld world) {
        this.world = world;
    }

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

    @Given("the range is {int}")
    public void the_range_is(int range) throws Throwable {
        world.network = new Network(range);
    }

    @Given("{person} is located at {int}")
    public void person_is_located_at(Person person, Integer location) {
        person.moveTo(location);
    }

    @Given("{person} has bought {int} credits")
    public void person_has_bought_credits(Person person, int credits) {
        person.setCredits(credits);
    }

    @When("{person} shouts")
    public void person_shouts(Person person) throws Throwable {
        shout(person, "Hello, world");
    }

    @When("{person} shouts {string}")
    public void person_shouts_message(Person person, String message) throws Throwable {
        shout(person, message);
    }

    @When("{person} shouts {int} messages containing the word {string}")
    public void person_shouts_messages_containing_the_word(Person person, int count, String word) throws Throwable {
        String message = "a message containing the word " + word;
        for (int i = 0; i < count; i++) {
            shout(person, message);
        }
    }

    @When("{person} shouts the following message")
    public void person_shouts_the_following_message(Person person, String message) throws Throwable {
        shout(person, message);
    }

    @When("{person} shouts {int} over-long messages")
    public void person_shouts_some_over_long_messages(Person person, int count) throws Throwable {
        String baseMessage = "A message from Sean that is 181 characters long ";
        String padding = "x";
        String overlongMessage = baseMessage + padding.repeat(181 - baseMessage.length());

        for (int i = 0; i < count; i++) {
            shout(person, overlongMessage);
        }
    }

    private void shout(Person person, String message) {
        person.shout(message);
        List<String> messages = world.messagesShoutedBy.get(person.getName());
        if (messages == null) {
            messages = new ArrayList<String>();
            world.messagesShoutedBy.put(person.getName(), messages);
        }
        messages.add(message);
    }

    @Then("{person} should hear Sean's message")
    public void person_hears_Sean_s_message(Person person) throws Throwable {
        List<String> messages = world.messagesShoutedBy.get("Sean");
        assertEquals(messages, person.getMessagesHeard());
    }

    @Then("{person} should not hear a shout")
    public void person_should_not_hear_a_shout(Person person) throws Throwable {
        assertEquals(0, person.getMessagesHeard().size());
    }

    @Then("{person} hears the following messages:")
    public void person_hears_the_following_messages(Person person, DataTable expectedMessages) {
        List<List<String>> actualMessages = new ArrayList<List<String>>();
        List<String> heard = person.getMessagesHeard();
        for (String message : heard) {
            actualMessages.add(Collections.singletonList(message));
        }
        expectedMessages.diff(DataTable.create(actualMessages));
    }

    @Then("{person} hears all Sean's messages")
    public void person_hears_all_Sean_s_messages(Person person) throws Throwable {
        List<String> heardByLucy = person.getMessagesHeard();
        List<String> messagesFromSean = world.messagesShoutedBy.get("Sean");

        // Hamcrest's hasItems matcher wants an Array, not a List.
        String[] messagesFromSeanArray = messagesFromSean.toArray(new String[messagesFromSean.size()]);
        assertThat(heardByLucy, hasItems(messagesFromSeanArray));
    }

    @Then("{person} should have {int} credits")
    public void person_should_have_credits(Person person, int expectedCredits) {
        assertEquals(expectedCredits, person.getCredits());
    }
}
