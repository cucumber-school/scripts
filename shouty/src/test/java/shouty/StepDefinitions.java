package shouty;

import io.cucumber.java.PendingException;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {
    Person lucy = new Person();
    Person sean = new Person();
    private String messageFromSean;

    @Given("Lucy is located/standing {int} metre(s) from Sean")
    public void lucy_is_metres_from_Sean(Integer distance) {
        throw new PendingException(String.format("Lucy is %d centimetres from Sean", distance * 100));
    }

    @When("Sean shouts {string}")
    public void sean_shouts(String message) {
        sean.shout(message);
        messageFromSean = message;
     }

    @Then("Lucy should hear Sean's message")
    public void lucy_should_hear_Sean_s_message() {
        assertEquals(asList(messageFromSean), lucy.getMessagesHeard());
    }
}
