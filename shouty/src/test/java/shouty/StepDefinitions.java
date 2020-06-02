package shouty;

import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.*;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.core.IsCollectionContaining.hasItem;
import static org.hamcrest.MatcherAssert.assertThat;

public class StepDefinitions {

    private static final int DEFAULT_RANGE = 100;
    private String messageFromSean;
    private Network network = new Network(DEFAULT_RANGE);
    private Map<String, Person> people;

    @Before
    public void createNetwork() {
        people = new HashMap<String, Person>();
    }

    @Given("the range is {int}")
    public void the_range_is(int range) throws Throwable {
        network = new Network(range);
    }

    @Given("a person named {word}")
    public void a_person_named(String name) throws Throwable {
        people.put(name, new Person(network, 0));
    }

    @Given("a person named {word} is located at {int}")
    public void a_person_named_is_located(String name, int location) throws Throwable {
        people.put(name, new Person(network, location));
    }

    @When("Sean shouts {string}")
    public void sean_shouts(String message) throws Throwable {
        people.get("Sean").shout(message);
        messageFromSean = message;
    }

    @Then("Lucy should hear Sean's message")
    public void lucy_hears_Sean_s_message() throws Throwable {
        assertEquals(Collections.singletonList(messageFromSean), people.get("Lucy").getMessagesHeard());
    }

    @Then("Larry should not hear Sean's message")
    public void larry_does_not_hear_Sean_s_message() throws Throwable {
        List<String> heardByLarry = people.get("Larry").getMessagesHeard();
        assertThat(heardByLarry, not(hasItem(messageFromSean)));
    }
}