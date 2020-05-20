package shouty;

import io.cucumber.java.ParameterType;
import io.cucumber.java.PendingException;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {
    Person lucy = new Person("Lucy");
    Person sean = new Person("Sean");
    private String messageFromSean;

    @Given("{person} is located/standing {int} metre(s) from Sean")
    public void person_is_metres_from_Sean(Person person, Integer distance) {
        person.moveTo(distance);
    }

    @When("{person} shouts {string}")
    public void sean_shouts(Person shouter, String message) {
        shouter.shout(message);
        messageFromSean = message;
     }

    @Then("Lucy should hear Sean's message")
    public void lucy_should_hear_Sean_s_message() {
        assertEquals(asList(messageFromSean), lucy.getMessagesHeard());
    }
}
