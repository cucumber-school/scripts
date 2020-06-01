package shouty;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {

    private Person sean;
    private Person lucy;
    private String messageFromSean;

    @Given("Lucy is {int} metres from Sean")
    public void lucy_is_located_m_from_Sean(int distance) throws Throwable {
        Network network = new Network();
        sean = new Person(network);
        lucy = new Person(network);
        lucy.moveTo(distance);
    }

    @Given("a person named Lucy")
    public void a_person_named_Lucy() {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }

    @Given("a person named Sean")
    public void a_person_named_Sean() {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }

    @When("Sean shouts {string}")
    public void sean_shouts(String message) throws Throwable {
        sean.shout(message);
        messageFromSean = message;
    }

    @Then("Lucy should hear Sean's message")
    public void lucy_hears_Sean_s_message() throws Throwable {
        assertEquals(asList(messageFromSean), lucy.getMessagesHeard());
    }
}
