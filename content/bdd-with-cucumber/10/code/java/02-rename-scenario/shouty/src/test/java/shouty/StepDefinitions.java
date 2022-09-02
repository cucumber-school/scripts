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
