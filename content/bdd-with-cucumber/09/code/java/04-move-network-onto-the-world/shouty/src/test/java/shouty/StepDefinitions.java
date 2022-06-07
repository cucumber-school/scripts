package shouty;

import io.cucumber.java.Before;
import io.cucumber.java.DataTableType;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.datatable.DataTable;
import shouty.support.ShoutyWorld;

import java.util.*;

import static org.hamcrest.CoreMatchers.hasItems;
import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.core.IsCollectionContaining.hasItem;
import static org.hamcrest.MatcherAssert.assertThat;

public class StepDefinitions {

    private ShoutyWorld world;
    private Map<String, Person> people;
    private Map<String, List<String>> messagesShoutedBy;

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

    @Before
    public void createNetwork() {
        people = new HashMap<String, Person>();
        messagesShoutedBy = new HashMap<String, List<String>>();
    }

    @Given("the range is {int}")
    public void the_range_is(int range) throws Throwable {
        world.network = new Network(range);
    }

    @Given("{word} is located at {int}")
    public void person_is_located_at(String name, Integer location) {
        Person person = new Person(world.network, location);
        people.put(name, person);
    }

    @Given("Sean has bought {int} credits")
    public void sean_has_bought_credits(int credits) {
        people.get("Sean").setCredits(credits);
    }

    @When("Sean shouts")
    public void sean_shouts() throws Throwable {
        shout("Hello, world");
    }

    @When("Sean shouts {string}")
    public void sean_shouts_message(String message) throws Throwable {
        shout(message);
    }

    @When("Sean shouts {int} messages containing the word {string}")
    public void sean_shouts_messages_containing_the_word(int count, String word) throws Throwable {
        String message = "a message containing the word " + word;
        for (int i = 0; i < count; i++) {
            shout(message);
        }
    }

    @When("Sean shouts the following message")
    public void sean_shouts_the_following_message(String message) throws Throwable {
        shout(message);
    }

    @When("Sean shouts {int} over-long messages")
    public void sean_shouts_some_over_long_messages(int count) throws Throwable {
        String baseMessage = "A message from Sean that is 181 characters long ";
        String padding = "x";
        String overlongMessage = baseMessage + padding.repeat(181 - baseMessage.length());

        for (int i = 0; i < count; i++) {
            shout(overlongMessage);
        }
    }

    private void shout(String message) {
        people.get("Sean").shout(message);
        List<String> messages = messagesShoutedBy.get("Sean");
        if (messages == null) {
            messages = new ArrayList<String>();
            messagesShoutedBy.put("Sean", messages);
        }
        messages.add(message);
    }

    @Then("Lucy should hear Sean's message")
    public void lucy_hears_Sean_s_message() throws Throwable {
        List<String> messages = messagesShoutedBy.get("Sean");
        assertEquals(messages, people.get("Lucy").getMessagesHeard());
    }

    @Then("{word} should not hear a shout")
    public void person_should_not_hear_a_shout(String name) throws Throwable {
        assertEquals(0, people.get(name).getMessagesHeard().size());
    }

    @Then("Lucy hears the following messages:")
    public void lucy_hears_the_following_messages(DataTable expectedMessages) {
        List<List<String>> actualMessages = new ArrayList<List<String>>();
        List<String> heard = people.get("Lucy").getMessagesHeard();
        for (String message : heard) {
            actualMessages.add(Collections.singletonList(message));
        }
        expectedMessages.diff(DataTable.create(actualMessages));
    }

    @Then("Lucy hears all Sean's messages")
    public void lucy_hears_all_Sean_s_messages() throws Throwable {
        List<String> heardByLucy = people.get("Lucy").getMessagesHeard();
        List<String> messagesFromSean = messagesShoutedBy.get("Sean");

        // Hamcrest's hasItems matcher wants an Array, not a List.
        String[] messagesFromSeanArray = messagesFromSean.toArray(new String[messagesFromSean.size()]);
        assertThat(heardByLucy, hasItems(messagesFromSeanArray));
    }

    @Then("Sean should have {int} credits")
    public void sean_should_have_credits(int expectedCredits) {
        assertEquals(expectedCredits, people.get("Sean").getCredits());
    }
}
